require 'spec/spec_helper'
describe Pipejump::Source do

  before do 
    @session = PipejumpSpec.session
    @source1 = @session.sources.create(:name => 'Source1')
    @source1.id.should_not be_nil
    @source2 = @session.sources.create(:name => 'Source2')
    @source2.id.should_not be_nil
  end
  
  after do
    @source1.destroy
    @source2.destroy
  end
  
  describe '@session.sources' do
    
    it ".all should return all sources" do
      @session.sources.all.collect(&:name).should == [@source1, @source2].collect(&:name) 
    end

    it ".first should return first source" do
      @session.sources.first.name.should == @source1.name
    end

    it ".last should return last source" do
      @session.sources.last.name.should == @source2.name
    end
    
    it ".find should find exact source" do
      @session.sources.find(@source1.id).name.should == @source1.name
    end
    
  end  
  
  describe '#method_missing' do
    
    it "should correctly get and set attributes" do 
      @source1.attributes.keys.sort.should == ['id', 'name']
      @source1.attributes.keys.each do |attribute|
        @source1.send(attribute).should == @source1.attributes[attribute]
      end
      @source1.name = 'Different name'
      @source1.name.should == 'Different name'
      @source1.attributes['name'].should == 'Different name'
    end
    
    it "should raise a NoMethodError when no accessor is set" do
      lambda {
        @source1.not_a_method_name
      }.should raise_error(NoMethodError)
    end
 
  end

  describe '#create' do
    
    it "should create record" do
      @source3 = @session.sources.create(:name => 'Source3')
      @source3.id.should_not be_nil
      @source3.name.should == 'Source3'
      @session.sources.find(@source3.id).name.should == 'Source3'
      @source3.destroy
    end
    
    it "should return error on validation fail" do
      @source3 = @session.sources.create(:name => '')
      @source3.id.should be_nil
      @source3.errors.should_not == {}      
    end
    
  end

  describe '#update' do
    
    it "should update record" do
      @source1.name = 'Different name'
      @source1.save.should == true
      @session.sources.find(@source1.id).name.should == 'Different name'
    end
    
    it "should return error on validation fail" do
      @source1.name = ''
      @source1.save.should == false
      @source1.errors.should_not == {}      
    end
    
  end

end