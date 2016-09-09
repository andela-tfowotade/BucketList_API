class BucketList < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true

  scope :paginate, lambda { |page, page_limit|
    page_limit = default_limit(page_limit.to_i)
    page_no = [page.to_i, 1].max - 1

    limit(page_limit).offset(page_limit.to_i * page_no)
  }

  scope :search, lambda { |query|
    query = query.downcase if query
    where("lower(name) like ?", "%#{query}%")
  }

  def self.paginate_and_search(params)
    paginate(params[:page], params[:limit]).search(params[:q])
  end

  private

  def self.default_limit(page_limit)
    page_limit = 20 if page_limit == 0
    page_limit = 100 if page_limit > 100
    page_limit
  end
end
