require 'spec/spec_helper'
describe Pipejump::Session do

  before do 
    @session = Pipejump::Session.new(AUTH.dup)
  end
  
  it "should have token" do
    @session.token.should_not be_nil
  end
  
  it "should raise an error on wrong credentials" do
    lambda {
      @session = Pipejump::Session.new(AUTH.merge({'password' => 'NOT_CORRECT_PASSWORD_123qwe'}).dup)
    }.should raise_error(Pipejump::AuthenticationFailed)
  end
  
  it "should return account data on /account" do
    account = @session.account
    account.class.should == Pipejump::Account
    account.attributes.keys.sort.should == ["currency_name", "id", "name"]
  end
  
  it "#connection should return a connection" do
    @session.connection.class.should == Pipejump::Connection
  end
  
  it "#clients should return a collection of clients" do
    @session.clients.class.should == Pipejump::Collection
  end

  it "#contacts should return a collection of contacts" do
    @session.contacts.class.should == Pipejump::Collection
  end

  it "#sources should return a collection of sources" do
    @session.sources.class.should == Pipejump::Collection
  end

  it "#deals should return a collection of deals" do
    @session.deals.class.should == Pipejump::Collection
  end
  
end 