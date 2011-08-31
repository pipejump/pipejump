require 'spec_helper'

describe Pipejump::Reminder do

  before do
    @session = PipejumpSpec.session
    @contact = @session.contacts.create(:name => 'contact1' + uuid)
    @valid = { :content => 'Some reminder', :remind => true, :hour => '13', :date => Time.now + 7 * 60 * 60 * 24 }
  end

  after do
    @contact.destroy
  end

  describe '#all' do

    before do
      @reminder = @contact.reminders.create(@valid)
    end

    after do
      @reminder.destroy
    end

    it "should fetch reminders within a contact" do
      @contact.reminders.size.should == 1
      last = @contact.reminders.last
      last.content.should == 'Some reminder'
      last.hour.to_i.should == 13
    end

  end

  describe '#find' do

    it "should find reminder" do
      @reminder = @contact.reminders.create(@valid)
      @found = @contact.reminders.find(@reminder.id)
      @found.content.should == 'Some reminder'
    end

    it "should raise an error if not found" do
      lambda {
        @contact.reminders.find(-1)
      }.should raise_error(Pipejump::ResourceNotFound)
    end

  end

  describe '#create' do

    describe 'with remind' do

      it "should create reminder with valid params" do
        @reminder = @contact.reminders.create(@valid)

        ["content", "created_at", "date", "done", "id", "remind", "hour", "updated_at"].each do |key|
          @reminder.attributes.keys.should include(key)
        end

        @reminder.destroy
      end

      it "should not create reminder with invalid params" do
        @reminder = @contact.reminders.create(:content => '', :remind => true)
        fields = @reminder.errors['reminder'].collect{ |e| e['error']['field'] }.sort
        fields.should include('content')
      end

    end

    describe 'without remind' do

      it "should create reminder with valid params" do
        @reminder = @contact.reminders.create(:content => 'Foo', :remind => false)
        ["content", "created_at", "date", "done", "id", "remind", "hour", "updated_at"].each do |key|
          @reminder.attributes.keys.should include(key)
        end
        @reminder.destroy
      end

      it "should not create reminder with invalid params" do
        @reminder = @contact.reminders.create(:content => '', :remind => false)
        @reminder.errors['reminder'].collect{ |e| e['error']['field'] }.sort.should == ["content"]
      end

    end

  end

  describe '#update' do

    before do
      @reminder = @contact.reminders.create(@valid)
    end

    after do
      @reminder.destroy
    end

    it "should update reminder with valid params" do
      @reminder.content = 'Updated reminder'
      @reminder.save.should == true
      @contact.reminders.find(@reminder.id).content.should == 'Updated reminder'
    end

    it "should not update reminder with invalid params" do
      @reminder.content = ''
      @reminder.save.should == false
      @reminder.errors['reminder'].collect{ |e| e['error']['field'] }.sort.should == ['content']
    end

  end

  describe '#destroy' do

    it "should destroy a reminder" do
      @reminder = @contact.reminders.create(@valid)
      @reminder.destroy.should == true
      lambda {
        @contact.reminders.find(@reminder.id)
      }.should raise_error(Pipejump::ResourceNotFound)

    end

  end

end
