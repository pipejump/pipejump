require 'spec_helper'

describe Pipejump::Deal do

  before do
    @session = PipejumpSpec.session
    @client = @session.contacts.create(:name => 'Client2' + uuid, :is_organisation => true)
    @client.id.should_not be_nil
  end

  after do
    @client.destroy
  end

  describe '#all' do
    it "should filter deals by stage" do
      deal = @session.deals.create(:name => 'New deal' + uuid, :entity_id => @client.id, :stage_name => "won")
      deals = @session.deals.all(:stage => "won")
      deals.size.should == 1
      deals[0].id.should == deal.id
    end

    it "by default fetches incoming deals" do
      deal = @session.deals.create(:name => 'New deal 2' + uuid, :entity_id => @client.id, :stage_name => "incoming")
      deals = @session.deals.all
      deals.size.should == 1
      deals[0].id.should == deal.id
    end
  end

  describe '#create' do

    it "should create deal with valid params" do
      @deal = @session.deals.create(:name => 'New deal' + uuid, :entity_id => @client.id)
      @deal.id.should_not be_nil
      ["entity_id", "deal_tags", "hot", "id", "last_stage_change_at", "name", "scope", "stage_name"].each do |key|
        @deal.attributes.keys.should include(key)
      end

      (@deal.attributes.keys - ['entity']).each do |attribute|
        @deal.send(attribute).should == @deal.attributes[attribute]
      end
      @deal.destroy
    end

    it "should return errors with invalid params" do
      @deal = @session.deals.create({})
      @deal.id.should == nil
      @deal.errors['deal'].collect{ |e| e['error']['field'] }.sort.should == ['entity_id', 'name']
    end

  end

  describe '.find' do

    it "should find deal" do
      @deal = @session.deals.create(:name => 'New deal' + uuid, :entity_id => @client.id)
      @found = @session.deals.find(@deal.id)
      @found.name == @deal.name
      @deal.destroy
    end

    it "should raise error if not found" do
      lambda {
        @session.deals.find(-1)
      }.should raise_error(Pipejump::ResourceNotFound)
    end
  end

  describe '#update' do

    before do
      @deal = @session.deals.create(:name => 'New deal' + uuid, :entity_id => @client.id)
    end

    after do
      @deal.destroy
    end

    it "should update deal with valid params" do
      @deal.name = 'Updated deal'
      @deal.save
      @deal.save.should == true
      @found = @session.deals.find(@deal.id)
      @found.name.should == 'Updated deal'
    end

    it "should return errors with invalid params" do
      @deal.name = ''
      @deal.save.should == false
      @deal.errors['deal'].collect{ |e| e['error']['field'] }.sort.should == ['name']
    end

  end

  describe '#contacts' do

    before do
      @deal = @session.deals.create(:name => 'New deal' + uuid, :entity_id => @client.id)
      @contact = @session.contacts.create(:name => 'Tom' + uuid, :contact_id => @client.id)
      @contact2 = @session.contacts.create(:name => 'Mike' + uuid, :contact_id => @client.id)
      @deal.contacts.update(@contact.id).should == true
    end

    after do
      @contact.destroy
      @contact2.destroy
    end

    it "should return a collection of contacts" do
      contacts = @deal.contacts
      contacts.class.should == Pipejump::Collection
      contacts.respond_to?(:update).should == true
      contacts.size.should == 1
    end

    describe '#update' do

      it "should update a collection of contacts and be smart about it" do
        @deal.contacts.update([@contact.id, @contact2.id])
        @deal.contacts.size.should == 2
        @deal.contacts.update([@contact])
        @deal.contacts.size.should == 1
        @deal.contacts.update([@contact.id, @contact2])
        @deal.contacts.size.should == 2
        @deal.contacts.update([@contact2.id])
        @deal.contacts.size.should == 1
        @deal.contacts.update([@contact.id, @contact2.id].join(','))
        @deal.contacts.size.should == 2
      end

    end

  end

end
