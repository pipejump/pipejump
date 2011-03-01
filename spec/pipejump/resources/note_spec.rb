require 'spec/spec_helper'
describe Pipejump::Note do
  
  before do 
    @session = PipejumpSpec.session
    @client = @session.clients.create(:name => 'Client1' + uuid)
    @deal = @session.deals.create(:name => 'New deal' + uuid, :client_id => @client.id)
  end

  after do
    @client.destroy
  end

  describe '#all' do
  
    before do
      @note = @deal.notes.create(:content => 'Some note')
    end
    
    after do
      @note.destroy
    end
    
    it "should fetch notes within a deal" do
      @deal.notes.size.should == 1
      @deal.notes.first.content.should == 'Some note'
    end

  end
  
  describe '#find' do

    it "should fetch notes within a deal" do
      @note = @deal.notes.create(:content => 'Some note')
      @found = @deal.notes.find(@note.id)
      @found.content.should == 'Some note'
    end

    it "should raise an error if not found" do
      lambda {
        @deal.notes.find(-1)
      }.should raise_error(Pipejump::ResourceNotFound)
    end
    
  end
  
  describe '#create' do
    
    it "should create note with valid params" do
      @note = @deal.notes.create(:content => 'Some note')
      @note.attributes.keys.sort.should == ["content", "created_at", "id", "updated_at", "username"] 
      @note.destroy
    end
    
    it "should not create note with invalid params" do
      @note = @deal.notes.create(:content => '')
      @note.errors['note'].collect{ |e| e['error']['field'] }.sort.should == ['content']
    end
    
  end
  
  describe '#update' do
    
    before do
      @note = @deal.notes.create(:content => 'Some note')
    end
    
    after do
      @note.destroy
    end
    
    it "should update note with valid params" do
      @note.content = 'Updated note'
      @note.save.should == true
      @deal.notes.find(@note.id).content.should == 'Updated note'
    end
    
    it "should not update note with invalid params" do
      @note.content = ''
      @note.save.should == false
      @note.errors['note'].collect{ |e| e['error']['field'] }.sort.should == ['content']  
    end
    
  end
  
  describe '#destroy' do
    
    it "should destroy a note" do
      @note = @deal.notes.create(:content => 'Some note')
      @note.destroy.should == true
      lambda {
        @deal.notes.find(@note.id)
      }.should raise_error(Pipejump::ResourceNotFound)
      
    end

  end
        
end
      