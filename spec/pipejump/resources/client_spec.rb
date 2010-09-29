require 'spec/spec_helper'
describe Pipejump::Client do

  before do 
    @session = PipejumpSpec.session
    @client1 = @session.clients.create(:name => 'Client1')
    @client1.id.should_not be_nil
    @client2 = @session.clients.create(:name => 'Client2')
    @client2.id.should_not be_nil
  end
  
  after do
    @client1.destroy
    @client2.destroy
  end
  
  describe '@session.clients' do
    
    it ".all should return all clients" do
      @session.clients.all.collect(&:name).should == [@client1, @client2].collect(&:name) 
    end

    it ".first should return first client" do
      @session.clients.first.name.should == @client1.name
    end

    it ".last should return last client" do
      @session.clients.last.name.should == @client2.name
    end
    
    it ".find should find exact client" do
      @session.clients.find(@client1.id).name.should == @client1.name
    end
    
  end  
  
  describe '#method_missing' do
    
    it "should correctly get and set attributes" do 
      @client1.attributes.keys.sort.should == ['id', 'name']
      @client1.attributes.keys.each do |attribute|
        @client1.send(attribute).should == @client1.attributes[attribute]
      end
      @client1.name = 'Different name'
      @client1.name.should == 'Different name'
      @client1.attributes['name'].should == 'Different name'
    end
    
    it "should raise a NoMethodError when no accessor is set" do
      lambda {
        @client1.not_a_method_name
      }.should raise_error(NoMethodError)
    end
 
  end

  describe '#create' do
    
    it "should create record" do
      @client3 = @session.clients.create(:name => 'Client3')
      @client3.id.should_not be_nil
      @client3.name.should == 'Client3'
      @session.clients.find(@client3.id).name.should == 'Client3'
      @client3.destroy
    end
    
    it "should return error on validation fail" do
      @client3 = @session.clients.create(:name => '')
      @client3.id.should be_nil
      @client3.errors.should_not == {}      
    end
    
  end

  describe '#update' do
    
    it "should update record" do
      @client1.name = 'Different name'
      @client1.save.should == true
      @session.clients.find(@client1.id).name.should == 'Different name'
    end
    
    it "should return error on validation fail" do
      @client1.name = ''
      @client1.save.should == false
      @client1.errors.should_not == {}      
    end
    
  end
  
  describe '#contacts' do
    
    before do
      @contact1 = @session.contacts.create(:name => 'contact1', :client_id => @client1.id)
      @contact2 = @session.contacts.create(:name => 'contact2', :client_id => @client1.id)
    end
    
    describe '#all' do
      
      it "should return contacts of a client" do
        contacts = @client1.contacts
        contacts.size.should == 2
        contacts.collect(&:name).should == ['contact1', 'contact2']
      end

    end

    describe '#find' do
      
      it "should return a single contact of a client" do
        contact = @client1.contacts.find(@contact1.id)
        contact.name == 'contact1'
      end
    
    end
    
  end

end