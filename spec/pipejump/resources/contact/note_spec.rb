require 'spec_helper'
describe Pipejump::Note do

  before do
    @session = PipejumpSpec.session
    @contact = @session.contacts.create(:name => 'contact1' + uuid)
  end

  after do
    @contact.destroy
  end

  describe '#all' do

    before do
      @note = @contact.notes.create(:content => 'Some note')
    end

    after do
      @note.destroy
    end

    it "should fetch notes within a contact" do
      @contact.notes.size.should == 1
      @contact.notes.first.content.should == 'Some note'
    end

  end

  describe '#find' do

    it "should fetch notes within a contact" do
      @note = @contact.notes.create(:content => 'Some note')
      @found = @contact.notes.find(@note.id)
      @found.content.should == 'Some note'
    end

    it "should raise an error if not found" do
      lambda {
        @contact.notes.find(-1)
      }.should raise_error(Pipejump::ResourceNotFound)
    end

  end

  describe '#create' do

    it "should create note with valid params" do
      @note = @contact.notes.create(:content => 'Some note')
      ["content", "created_at", "id", "updated_at", "username"].each do |key|
        @note.attributes.keys.should include(key)
      end
      @note.destroy
    end

    it "should not create note with invalid params" do
      @note = @contact.notes.create(:content => '')
      @note.errors['note'].collect{ |e| e['error']['field'] }.sort.should == ['content']
    end

  end

  describe '#update' do

    before do
      @note = @contact.notes.create(:content => 'Some note')
    end

    after do
      @note.destroy
    end

    it "should update note with valid params" do
      @note.content = 'Updated note'
      @note.save.should == true
      @contact.notes.find(@note.id).content.should == 'Updated note'
    end

    it "should not update note with invalid params" do
      @note.content = ''
      @note.save.should == false
      @note.errors['note'].collect{ |e| e['error']['field'] }.sort.should == ['content']
    end

  end

  describe '#destroy' do

    it "should destroy a note" do
      @note = @contact.notes.create(:content => 'Some note')
      @note.destroy.should == true
      lambda {
        @contact.notes.find(@note.id)
      }.should raise_error(Pipejump::ResourceNotFound)

    end

  end

end
