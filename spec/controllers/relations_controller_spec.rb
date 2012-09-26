require 'spec_helper'

describe RelationsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  
  before { sign_in user }
  
  describe "creating a relation with Ajax" do

    it "should increment the Relation count" do
      expect do
        xhr :post, :create, relation: { followed_id: other_user.id }
      end.to change(Relation, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relation: { followed_id: other_user.id }
      response.should be_success
    end
  end
  
  describe "destroying a relation with Ajax" do
    
    before { user.follow!(other_user) }
    let(:relation) { user.relations.find_by_followed_id(other_user) }

    it "should decrement the Relation count" do
      expect do
        xhr :delete, :destroy, id: relation.id
      end.to change(Relation, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relation.id
      response.should be_success
    end
  end
end