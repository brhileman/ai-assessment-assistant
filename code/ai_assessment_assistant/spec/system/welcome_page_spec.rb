require "rails_helper"

RSpec.describe "Welcome Page", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "displays the welcome page successfully" do
    visit root_path
    
    expect(page).to have_selector("h1", text: "AI Assessment Assistant")
    expect(page).to have_text("Streamline your AI readiness evaluation")
  end

  it "displays the LaunchPad Lab logo" do
    visit root_path
    
    # Check that logo images are present with correct alt text
    expect(page).to have_selector("img[alt='LaunchPad Lab']")
  end

  it "has navigation elements" do
    visit root_path
    
    expect(page).to have_link("About")
    expect(page).to have_link("Admin Login")
    expect(page).to have_selector("nav")
  end

  it "displays feature cards" do
    visit root_path
    
    expect(page).to have_text("Voice Assessments")
    expect(page).to have_text("Real-time Transcripts") 
    expect(page).to have_text("Secure & Compliant")
  end

  it "has contact information" do
    visit root_path
    
    expect(page).to have_link("Contact Us", href: "mailto:assessment@launchpadlab.com")
    expect(page).to have_text("Ready to get started?")
  end
end 