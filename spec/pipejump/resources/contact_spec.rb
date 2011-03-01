require 'spec/spec_helper'
describe Pipejump::Contact do

  before do 
    @session = PipejumpSpec.session
    @client = @session.clients.create(:name => 'Client1')
    @contact1 = @session.contacts.create(:name => 'contact1', :client_id => @client.id)
    @contact1.id.should_not be_nil
    @contact2 = @session.contacts.create(:name => 'contact2', :client_id => @client.id)
    @contact2.id.should_not be_nil
  end
  
  after do
    @client.destroy
    @contact1.destroy
    @contact2.destroy
  end
  
  describe '@session.contacts' do
    
    it ".all should return all contacts" do
      @session.contacts.all.collect(&:name).include?(@contact1.name).should == true
      @session.contacts.all.collect(&:name).include?(@contact2.name).should == true
    end

    it ".first should return first client" do
      @session.contacts.first.class.should == Pipejump::Contact
    end

    it ".last should return last client" do
      @session.contacts.last.class.should == Pipejump::Contact
    end
    
    it ".find should find exact contact" do
      @session.contacts.find(@contact1.id).name.should == @contact1.name
    end
    
  end  
  
  describe '#method_missing' do
    
    it "should correctly get and set attributes" do 
      ["client_id", "email", "id", "mobile", "name", "phone", 'private'].each do |key|
        @contact1.attributes.keys.include?(key).should == true
      end
      @contact1.attributes.keys.each do |attribute|
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
      @contact3 = @session.contacts.create(:name => 'contact3', :client_id => @client.id)
      @contact3.id.should_not be_nil
      @contact3.name.should == 'contact3'
      @session.contacts.find(@contact3.id).name.should == 'contact3'
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
      @contact1.name = 'Different name'
      @contact1.save.should == true
      @session.contacts.find(@contact1.id).name.should == 'Different name'
    end
    
    it "should return error on validation fail" do
      @contact1.name = ''
      @contact1.save.should == false
      @contact1.errors.should_not == {}      
    end
    
  end

end