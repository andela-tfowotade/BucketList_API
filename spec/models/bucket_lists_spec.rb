require "rails_helper"

describe BucketList, type: :model do
  describe "instance methods" do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:created_by) }
  end

  describe "ActiveModel Validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to belong_to(:user) }
  end

  describe ".paginate" do
    context "when there are no bucket lists created" do
      it "returns an empty array" do
        expect(BucketList.paginate(1, 2)).to eq([])
      end
    end

    context "when bucket lists have been created" do
      it "returns a paginated bucket list" do
        3.times { create(:bucket_list) }
                
        expect(BucketList.paginate(1, 2).count).to eq(2)
        expect(BucketList.paginate(2, 2).count).to eq(1)
      end
    end

    context "when paginate parameter is not supplied" do
      it "defaults to 20 bucketlist per page" do
        30.times { create(:bucket_list) }

        expect(BucketList.paginate(nil, nil).count).to eq(20)
      end
    end

    context "when page limit is greater than 100" do
      it "defaults to 100 bucketlist per page" do
        110.times { create(:bucket_list) }

        expect(BucketList.paginate(1, 110).count).to eq(100)
      end
    end
  end

  describe ".search" do
    context "when query matches a bucket list" do
      it "returns the filtered list using the query supplied" do
        john = create(:bucket_list, name: "Cities I'll travel to")
        peter = create(:bucket_list, name: "Career goals")

        expect(BucketList.search("travel")).to eq([john])
      end
    end

    context "when query doesn't match a bucket list" do
      it "returns an empty array" do
        expect(BucketList.search("travel")).to eq([])
      end
    end
  end

  describe ".paginate_and_search" do
    context "with empty bucket list" do
      it "returns an empty array" do
        paginated_search = BucketList.paginate_and_search(
          q: "travel",
          page: 1,
          limit: 2
        )

        expect(paginated_search).to eq([])
      end
    end

    context "with bucket lists present" do
      it "returns the paginated and query filtered list" do
        john = create(:bucket_list, name: "Cities I'll travel to")
        peter = create(:bucket_list, name: "Career goals")

        paginated_search = BucketList.paginate_and_search(
          q: "travel",
          page: 1,
          limit: 2
        )

        expect(paginated_search).to eq([john])
      end
    end
  end
end
