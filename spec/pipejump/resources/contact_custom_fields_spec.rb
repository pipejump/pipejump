require 'spec_helper'

describe Pipejump::Contact do

  before do
    @session = PipejumpSpec.session
    @contact = @session.contacts.create(:name => 'contact1'+uuid)
  end

  after do
    @contact.destroy
  end

  describe "#custom_fields" do

    it "returns a hash of custom fields" do
      @contact.custom_fields['test_field'] = 'yaaay'
      @contact.save.should == true

      @session.contacts.find(@contact.id).custom_fields['test_field'].should =='yaaay'
    end
  end

end

