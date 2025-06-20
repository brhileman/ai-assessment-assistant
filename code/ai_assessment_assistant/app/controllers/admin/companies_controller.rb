class Admin::CompaniesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    # Simple company list for MVP - no search/filter functionality needed
    @companies = Company.includes(:stakeholders, :assessments).order(:name)
  end

  def show
    @stakeholders = @company.stakeholders.includes(:assessment).order(:name)
    @recent_assessments = @company.assessments.completed.recent.limit(5)
    @completion_rate = @company.completion_rate
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to admin_company_path(@company), notice: 'Company was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to admin_company_path(@company), notice: 'Company was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    company_name = @company.name
    @company.destroy!
    redirect_to admin_companies_path, notice: "Company '#{company_name}' was successfully deleted."
  rescue ActiveRecord::InvalidForeignKey
    redirect_to admin_company_path(@company), alert: 'Cannot delete company with existing stakeholders. Remove all stakeholders first.'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :custom_instructions)
  end
end
