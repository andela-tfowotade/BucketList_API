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

  describe ".paginate" do
    context "when bucket lists have been created" do
      it "returns a paginated bucket list" do
        john = create(:bucket_list)
        peter = create(:bucket_list)
        paul = create(:bucket_list)

        expect(BucketList.paginate(1,2)).to eq([john, peter])
      end
    end

    context "when there are no bucket lists created" do
      it "returns an empty array" do
        expect(BucketList.paginate(1,2)).to eq([])
      end
    end
  end

  describe ".search" do
    context "when query matches a bucket list" do
      it "returns the filtered list using the query supplied" do
        john = create(:bucket_list, name: "Cities I'll travel to")
        peter = create(:bucket_list, name: "Career goals")

        expect(BucketList.search({q: "travel"})).to eq([john])
      end
    end

    context "when query doesn't match a bucket list" do
      it "returns an empty array" do
        expect(BucketList.search({q: "travel"})).to eq([])
      end
    end
  end

  describe ".paginate_and_search" do
    context "with empty bucket list" do 
      it "returns an empty array" do
        expect(BucketList.paginate_and_search({q: "bucket", page: 1, limit: 2})).to eq([])
      end
    end

    context "with bucket lists present" do
      it "returns the paginated and query filtered list" do
        john = create(:bucket_list, name: "Cities I'll travel to")
        peter = create(:bucket_list, name: "Career goals")

        expect(BucketList.paginate_and_search({q: "travel", page: 1, limit: 2})).to eq([john])
      end
    end
  end
end