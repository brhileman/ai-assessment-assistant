class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    # Admin dashboard home page
    @admin = current_admin
    
    # Dashboard Statistics
    @total_companies = Company.count
    @total_stakeholders = Stakeholder.count
    @total_assessments = Assessment.count
    @completed_assessments = Assessment.completed.count
    @pending_assessments = Assessment.in_progress.count + Stakeholder.where(status: :invited).count
    
    # Completion Rates
    @overall_completion_rate = @total_assessments > 0 ? (@completed_assessments.to_f / @total_assessments * 100).round(1) : 0
    @average_company_completion_rate = Company.joins(:stakeholders).joins('LEFT JOIN assessments ON assessments.stakeholder_id = stakeholders.id')
                                              .group('companies.id')
                                              .average('CASE WHEN assessments.completed_at IS NOT NULL THEN 100.0 ELSE 0.0 END')
                                              .values.sum / [@total_companies, 1].max
    
    # Recent Activity (last 10 completed assessments)
    @recent_assessments = Assessment.completed
                                   .joins(stakeholder: :company)
                                   .includes(stakeholder: :company)
                                   .order(completed_at: :desc)
                                   .limit(10)
    
    # Assessment Duration Statistics
    @average_duration = Assessment.average_duration_minutes
    
    # Company Performance
    @top_performing_companies = Company.joins(stakeholders: :assessment)
                                       .where.not(assessments: { completed_at: nil })
                                       .group('companies.id, companies.name')
                                       .select('companies.id, companies.name, COUNT(assessments.id) as completed_count')
                                       .order('completed_count DESC')
                                       .limit(5)
    
    # Assessment Activity by Day (last 7 days)
    @daily_activity = (6.days.ago.to_date..Date.current).map do |date|
      {
        date: date,
        completed: Assessment.where(completed_at: date.beginning_of_day..date.end_of_day).count,
        started: Assessment.where(created_at: date.beginning_of_day..date.end_of_day, completed_at: nil).count
      }
    end
    
    # Quick Stats for Cards
    @stats = {
      companies: {
        total: @total_companies,
        with_assessments: Company.joins(stakeholders: :assessment).distinct.count,
        completion_rate: @average_company_completion_rate.round(1)
      },
      stakeholders: {
        total: @total_stakeholders,
        invited: Stakeholder.where(status: :invited).count,
        in_progress: Stakeholder.where(status: :assessment_started).count,
        completed: Stakeholder.where(status: :assessment_completed).count
      },
      assessments: {
        total: @total_assessments,
        completed: @completed_assessments,
        in_progress: @pending_assessments,
        completion_rate: @overall_completion_rate,
        avg_duration: @average_duration
      }
    }
  end
  
  private
  
  def authenticate_admin!
    redirect_to new_admin_magic_link_path unless admin_signed_in?
  end
end 