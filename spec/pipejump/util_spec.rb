require "spec_helper"

describe Pipejump::Util do

  describe ".to_query" do

    it "works with a simple hash" do
      result = Pipejump::Util.to_query :a => 1, :b => 1
      result.should == "a=1&b=1"
    end

    it "works with a nested hash" do
      result = Pipejump::Util.to_query :a => 1, :b => { :c => 1 }
      result.should == "a=1&b[c]=1"
    end

    it "works with an array" do
      result = Pipejump::Util.to_query :a => [1,2]
      result.should == "a[]=1&a[]=2"
    end
  end
  
end
