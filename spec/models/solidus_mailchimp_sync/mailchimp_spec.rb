require 'spec_helper'

RSpec.describe SolidusMailchimpSync::Mailchimp, type: :model do
  it "return the full base url for mailchimp endpoints" do
    allow(SolidusMailchimpSync).to receive(:data_center).and_return("us1")
    expect(subject.class.base_url).to eq "https://us1.api.mailchimp.com/3.0/"
  end
  it "return the full url for the specific path for a mailchimp endpoint" do
    allow(SolidusMailchimpSync).to receive(:data_center).and_return("us1")
    expect(subject.class.url('/ecommerce/stores')).to eq "https://us1.api.mailchimp.com/3.0/ecommerce/stores"
  end
  it "return nil if SolidusMailchimpSync is not enable" do
    allow(SolidusMailchimpSync).to receive(:enabled).and_return(false)
    expect(subject.class.request(:get, '/ecommerce/stores', body: {}, return_errors: false)).to be_nil
  end
end
