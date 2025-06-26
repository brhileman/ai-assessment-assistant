require 'rails_helper'

RSpec.describe "Stakeholder Invitation Management", type: :system do
  let!(:admin) { create(:admin) }
  let!(:company) { create(:company, name: "Test Company") }
  
  before do
    # Login as admin using magic link
    visit new_admin_magic_link_path
    fill_in "Email", with: admin.email
    click_button "Send Magic Link"
    
    # Simulate clicking the magic link
    admin.reload
    visit admin_magic_link_auth_path(admin_magic_link_token: admin.magic_link_token)
  end

  describe "Adding and managing stakeholders" do
    it "allows adding a new stakeholder and sending invitation" do
      visit admin_company_path(company)
      
      # Click add stakeholder button
      click_link "Add Stakeholder"
      
      # Fill in stakeholder details
      fill_in "Name", with: "John Doe"
      fill_in "Email", with: "john.doe@example.com"
      click_button "Add Stakeholder"
      
      # Verify stakeholder was added
      expect(page).to have_content("John Doe has been added and invitation email sent")
      expect(page).to have_content("John Doe")
      expect(page).to have_content("john.doe@example.com")
      expect(page).to have_content("Invited")
      
      # Verify invitation timestamp is shown
      within(".divide-y") do
        expect(page).to have_content("Invited")
        expect(page).to have_content("ago")
      end
    end

    context "with existing stakeholder" do
      let!(:stakeholder) { create(:stakeholder, company: company, name: "Jane Smith", email: "jane@example.com", invitation_sent_at: 2.hours.ago) }
      
      before do
        create(:assessment, stakeholder: stakeholder)
      end

      it "shows resend button for invited stakeholders" do
        visit admin_company_path(company)
        
        within(".divide-y") do
          expect(page).to have_content("Jane Smith")
          expect(page).to have_content("jane@example.com")
          expect(page).to have_content("In Progress")
          expect(page).to have_content("Invitation sent 2 hours ago")
          expect(page).to have_link("Resend")
        end
      end

      it "allows resending invitation with confirmation" do
        visit admin_company_path(company)
        
        # Test confirmation dialog
        accept_confirm "Resend invitation email to jane@example.com?" do
          within(".divide-y") do
            click_link "Resend"
          end
        end
        
        # Verify success message
        expect(page).to have_content("Invitation email resent to Jane Smith (jane@example.com)")
        
        # Verify timestamp was updated (should now show "less than a minute ago")
        within(".divide-y") do
          expect(page).to have_content("Invitation sent less than a minute ago")
        end
      end

      it "can cancel resend invitation" do
        visit admin_company_path(company)
        
        # Cancel the confirmation dialog
        dismiss_confirm do
          within(".divide-y") do
            click_link "Resend"
          end
        end
        
        # Verify no action was taken
        expect(page).not_to have_content("Invitation email resent")
        
        # Timestamp should remain unchanged
        within(".divide-y") do
          expect(page).to have_content("Invitation sent 2 hours ago")
        end
      end

      context "when stakeholder has completed assessment" do
        let!(:completed_stakeholder) { create(:stakeholder, :assessment_completed, company: company, name: "Bob Wilson") }

        it "does not show resend button for completed assessments" do
          visit admin_company_path(company)
          
          # Find the completed stakeholder's row
          within(".divide-y") do
            stakeholder_row = find("div", text: "Bob Wilson").ancestor("div.px-6.py-4")
            within(stakeholder_row) do
              expect(page).to have_content("Completed")
              expect(page).not_to have_link("Resend")
              expect(page).to have_link("View Results")
            end
          end
        end
      end
    end

    describe "Removing stakeholders" do
      let!(:stakeholder) { create(:stakeholder, company: company, name: "To Remove") }

      it "allows removing stakeholder with confirmation" do
        visit admin_company_path(company)
        
        accept_confirm "Are you sure you want to remove To Remove? This will also delete their assessment data." do
          within(".divide-y") do
            click_link "Remove"
          end
        end
        
        expect(page).to have_content("Stakeholder To Remove has been removed")
        expect(page).not_to have_content("To Remove")
      end
    end

    describe "Visual elements and styling" do
      let!(:stakeholder) { create(:stakeholder, company: company) }

      it "displays email icon on resend button" do
        visit admin_company_path(company)
        
        within(".divide-y") do
          resend_link = find_link("Resend")
          
          # Check for hover effects
          expect(resend_link[:class]).to include("hover:bg-blue-50")
          expect(resend_link[:class]).to include("hover:text-blue-800")
          
          # Check for email icon
          within(resend_link) do
            expect(page).to have_css("svg")
          end
        end
      end
    end
  end
end 