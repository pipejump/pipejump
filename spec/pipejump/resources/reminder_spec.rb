require 'spec/spec_helper'
describe Pipejump::Reminder do
  
  before do 
    @session = PipejumpSpec.session
    @client = @session.clients.create(:name => 'Client1')
    @deal = @session.deals.create(:name => 'New deal', :client_id => @client.id)
    @valid = { :content => 'Some reminder', :time => '13:00', :date => Time.now + 7 * 60 * 60 * 24 }
  end

  after do
    @client.destroy
  end

  describe '#all' do
  
    before do
      @reminder = @deal.reminders.create(@valid)
    end
    
    after do
      @reminder.destroy
    end
    
    it "should fetch reminders within a deal" do
      @deal.reminders.size.should == 1
      @deal.reminders.first.content.should == 'Some reminder'
      @deal.reminders.first.time.should == '13:00'
    end

  end
  
  describe '#find' do

    it "should find reminder" do
      @reminder = @deal.reminders.create(@valid)
      @found = @deal.reminders.find(@reminder.id)
      @found.content.should == 'Some reminder'
    end

    it "should raise an error if not found" do
      lambda {
        @deal.reminders.find(-1)
      }.should raise_error(Pipejump::ResourceNotFound)
    end
    
  end
  
  describe '#create' do
    
    it "should create reminder with valid params" do
      @reminder = @deal.reminders.create(@valid)
      @reminder.attributes.keys.sort.should == ["content", "date", "done", "id", "time"]
      @reminder.destroy
    end
    
    it "should not create reminder with invalid params" do
      @reminder = @deal.reminders.create(:content => '')
      @reminder.errors['reminder'].collect{ |e| e['error']['field'] }.sort.should == ["content", "date", "time"]
    end
    
  end
  
  describe '#update' do
    
    before do
      @reminder = @deal.reminders.create(@valid)
    end
    
    after do
      @reminder.destroy
    end
    
    it "should update reminder with valid params" do
      @reminder.content = 'Updated reminder'
      @reminder.save.should == true
      @deal.reminders.find(@reminder.id).content.should == 'Updated reminder'
    end
    
    it "should not update reminder with invalid params" do
      @reminder.content = ''
      @reminder.save.should == false
      @reminder.errors['reminder'].collect{ |e| e['error']['field'] }.sort.should == ['content']  
    end
    
  end
  
  describe '#destroy' do
    
    it "should destroy a reminder" do
      @reminder = @deal.reminders.create(@valid)
      @reminder.destroy.should == true
      lambda {
        @deal.reminders.find(@reminder.id)
      }.should raise_error(Pipejump::ResourceNotFound)
      
    end

  end
        
end
