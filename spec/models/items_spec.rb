require "rails_helper"

describe Item, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:done) }
  end

  describe "ActiveModel Validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to belong_to(:bucket_list) }
  end
end
