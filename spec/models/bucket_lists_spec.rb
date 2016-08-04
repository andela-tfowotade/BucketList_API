require "rails_helper"

describe BucketList, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:created_by) }
  end

  describe "ActiveModel Validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:created_by) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to belong_to(:user) }
  end
end