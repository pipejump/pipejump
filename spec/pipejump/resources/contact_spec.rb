require 'spec_helper'

describe Pipejump::Contact do

  before do
    @session = PipejumpSpec.session
    @organisation = @session.contacts.create(:name => 'Client1'+uuid, :is_organisation => true)
    @contact1 = @session.contacts.create(:name => 'contact1'+uuid, :contact_id => @organisation.id)
    @contact1.id.should_not be_nil
    @contact2 = @session.contacts.create(:name => 'contact2'+uuid, :contact_id => @organisation.id)
    @contact2.id.should_not be_nil
  end

  after do
    @organisation.destroy
    @contact1.destroy
    @contact2.destroy
  end


  describe '@session.contacts' do

    it ".all should return all contacts" do
      @session.contacts.all.collect(&:name).include?(@contact1.name).should == true
      @session.contacts.all.collect(&:name).include?(@contact2.name).should == true
    end

    it ".first should return first organisation" do
      @session.contacts.first.class.should == Pipejump::Contact
    end

    it ".last should return last organisation" do
      @session.contacts.last.class.should == Pipejump::Contact
    end

    it ".find should find exact contact" do
      @session.contacts.find(@contact1.id).name.should == @contact1.name
    end

  end

  describe '#method_missing' do

    it "should correctly get and set attributes" do
      ["contact_id", "email", "id", "mobile", "name", "phone", 'private'].each do |key|
        @contact1.attributes.keys.include?(key).should == true
        @contact1.should respond_to(key.to_sym)
      end
      (@contact1.attributes.keys - ['organisation']).each do |attribute|
        @contact1.send(attribute).should == @contact1.attributes[attribute]
      end
      @contact1.name = 'Different name'
      @contact1.name.should == 'Different name'
      @contact1.attributes['name'].should == 'Different name'
    end

    it "should raise a NoMethodError when no accessor is set" do
      lambda {
        @contact1.not_a_method_name
      }.should raise_error(NoMethodError)
    end

  end

  describe '#create' do

    it "should create record" do
      name = 'contact3'+uuid
      @contact3 = @session.contacts.create(:name => name, :contact_id => @organisation.id)
      @contact3.id.should_not be_nil
      @contact3.name.should == name
      @session.contacts.find(@contact3.id).name.should == name
      @contact3.destroy
    end

    it "should return error on validation fail" do
      @contact3 = @session.contacts.create(:name => '')
      @contact3.id.should be_nil
      @contact3.errors.should_not == {}
    end

  end

  describe '#update' do

    it "should update record" do
      name = "Different name #{uuid}"
      @contact1.name = name
      @contact1.last_name = name
      @contact1.save.should == true
      @session.contacts.find(@contact1.id).name.should == name
    end

    it "should return error on validation fail" do
      @contact1.name = ''
      @contact1.last_name = ''
      @contact1.save.should == false
      @contact1.errors.should_not == {}
    end

  end

end
