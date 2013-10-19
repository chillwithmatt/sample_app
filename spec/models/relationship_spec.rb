require 'spec_helper'

describe Relationship do
  let(:a) { FactoryGirl.create(:user) }
  let(:b) { FactoryGirl.create(:user) }
  let(:relationship) { a.relationships.build(followed_id: b.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq a }
    its(:followed) { should eq b }
  end
end
