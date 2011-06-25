require 'spec_helper'

describe Relationship do
  
  describe "validations" do
    # check to see if required attributes are enforced.
    [:follower_id, :followed_id].each do |attr|
      it "must have a " + attr.to_s do
        r = Relationship.new
        r.should_not be_valid
        r.errors_on(:attr).should_not be_nil
      end
    end
    
    # check to see if its valid if you enter enough info
    it "should be valid if you enter a follower_id and followed_id" do
      r = Relationship.new
      r.should_not be_valid
      
      r = Factory.create(:relationship, :follower_id => 1, :followed_id => 1)
      r.should be_valid
    end  
  end
  
  describe "assocations" do
    it "should respond to followers method" do
      r = Relationship.new
      r.should respond_to(:follower)
    end
    
    it "should respond to followed method" do
      r = Relationship.new
      r.should respond_to(:followed)
    end
  end
  
end
