require 'rails_helper'

RSpec.describe OpenaiRealtimeService do
  let(:company) { create(:company) }
  let(:stakeholder) { create(:stakeholder, company: company) }
  
  describe '#initialize' do
    context 'when OpenAI API key is in environment variables' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return('test-api-key')
      end
      
      it 'initializes successfully' do
        expect { described_class.new(stakeholder) }.not_to raise_error
      end
    end
    
    context 'when OpenAI API key is in Rails credentials' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return(nil)
        allow(Rails.application.credentials).to receive(:dig).with(:openai, :api_key).and_return('test-api-key')
      end
      
      it 'initializes successfully' do
        expect { described_class.new(stakeholder) }.not_to raise_error
      end
    end
    
    context 'when OpenAI API key is missing' do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return(nil)
        allow(ENV).to receive(:[]).with('OPENAI_ORGANIZATION_ID').and_return(nil)
        allow(Rails.application.credentials).to receive(:dig).and_return(nil)
      end
      
      it 'raises an error' do
        expect { described_class.new(stakeholder) }.to raise_error(
          RuntimeError, 
          "OpenAI API key not found in environment variables or credentials"
        )
      end
    end
  end
  
  describe '#create_conversation_session' do
    let(:service) { described_class.new(stakeholder) }
    
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('OPENAI_API_KEY').and_return('test-api-key')
      
      # Mock the HTTP request for ephemeral token generation
      stub_request(:post, "https://api.openai.com/v1/realtime/sessions")
        .to_return(
          status: 200,
          body: {
            client_secret: { value: 'test-ephemeral-token' }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end
    
    it 'creates a session configuration' do
      session_config = service.create_conversation_session
      
      expect(session_config).to include(
        :session_id,
        :ephemeral_token,
        :api_endpoint,
        :model,
        :voice,
        :instructions
      )
      expect(session_config[:ephemeral_token]).to eq('test-ephemeral-token')
      expect(session_config[:model]).to eq('gpt-4o-realtime-preview-2024-10-01')
    end
  end
end 