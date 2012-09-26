require 'spec_helper'

describe Relation do
  
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relation) { follower.relations.build(followed_id: followed.id) }
  
  subject { relation }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relation.new(follower_id: follower.id)
        should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end
  
  describe "follower methods" do
    
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end
  
  describe "when follower id is not present" do
    before {relation.follower_id = nil }
    it { should_not be_valid }
  end
  
  describe "when followed id is not present" do
    before {relation.followed_id = nil }
    it { should_not be_valid }
  end
end
