require 'spec_helper'

RSpec.describe SolidusMailchimpSync::Mailchimp, type: :model do
  context 'Mailchimp datacenter is US1' do
    before(:each) do
      allow(SolidusMailchimpSync).to receive(:data_center).and_return("us1")  
    end
    
    it ".base_url return the full base url for mailchimp endpoints" do
      expect(subject.class.base_url).to eq "https://us1.api.mailchimp.com/3.0/"
    end
    it ".url return the full url for the specific path for a mailchimp endpoint" do
      expect(subject.class.url('/ecommerce/stores')).to eq "https://us1.api.mailchimp.com/3.0/ecommerce/stores"
    end
  end

  context ' SolidusMailchimpSync is not enable' do
    before do
      allow(SolidusMailchimpSync).to receive(:enabled).and_return(false)  
    end
      
    it ".request return nil" do
      expect(subject.class.request(:get, '/ecommerce/stores', body: {}, return_errors: false)).to be_nil
    end
  end

  context ' SolidusMailchimpSync is enable' do
    before do
      allow(SolidusMailchimpSync).to receive(:enabled).and_return(true)  
    end
      
    context ' SolidusMailchimpSync api_key is blank' do
      it ".request raise error" do
        allow(SolidusMailchimpSync).to receive(:api_key).and_return(nil) 
        expect{subject.class.request(:get, '/ecommerce/stores', body: '', return_errors: false)}.to raise_error(ArgumentError, 'Missing required configuration `SolidusMailchimpSync.api_key`')
      end
    end

    context 'response generates error' do
      it ".request raise error" do
        response = double()
        allow(response).to receive(:body).and_return('{}') 
        allow(response).to receive(:code).and_return('Error 400') 
        allow(HTTP).to receive(:basic_auth).with(anything).and_return(HTTP) 
        allow(HTTP).to receive(:request).with(any_args).and_return(response) 
        expect{subject.class.request(:get, '/ecommerce/stores', body: '', return_errors: false)}.to raise_error('Error 400')
      end
    end
  end
end
