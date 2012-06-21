require 'spec_helper'

describe Pipejump::Contact do

  describe "validation" do

    it "does not save when not valid" do
      @contact = Pipejump::Contact.new(:name => '')
      @contact.save.should be_false
    end

    it "is not valid when name is not set" do
      @contact = Pipejump::Contact.new(:name => 'foo')
      @contact.valid?.should be_true
      @contact.name = ''
      @contact.valid?.should be_false
    end

    it "is not valid when last_name is not set" do
      @contact = Pipejump::Contact.new(:last_name => 'foo')
      @contact.valid?.should be_true
      @contact.last_name = ''
      @contact.valid?.should be_false
    end

  end

end

