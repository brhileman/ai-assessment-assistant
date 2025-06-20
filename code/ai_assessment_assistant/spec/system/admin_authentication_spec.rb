require "rails_helper"

RSpec.describe "Admin Authentication", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "displays the admin login page" do
    visit new_admin_magic_link_path
    
    expect(page).to have_selector("h2", text: "Admin Login")
    expect(page).to have_selector("img[alt='LaunchPad Lab']")
    expect(page).to have_field("Email")
    expect(page).to have_button("Send Magic Link")
  end

  it "shows admin login link from welcome page" do
    visit root_path
    
    expect(page).to have_link("Admin Login", href: new_admin_magic_link_path)
    
    click_link "Admin Login"
    expect(page).to have_current_path(new_admin_magic_link_path)
    expect(page).to have_selector("h2", text: "Admin Login")
  end

  it "displays proper branding and styling" do
    visit new_admin_magic_link_path
    
    expect(page).to have_text("AI Assessment Assistant")
    expect(page).to have_selector("img[alt='LaunchPad Lab']")
    expect(page).to have_text("Passwordless authentication via email")
    expect(page).to have_link("← Back to Main Site", href: root_path)
  end
end 