class BucketList < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :created_by, presence: true

  scope :paginate, lambda { |page, page_limit|
    default_limit(page_limit)
    page_no = [page.to_i, 1].max - 1

    limit(page_limit).offset(page_limit.to_i * page_no)
  }

  scope :search, -> (query) {
    query_lower = query.downcase if query
    where("lower(name) like ?", "%#{query_lower}%")
  }

  def self.paginate_and_search(params)
    paginate(params[:page], params[:limit]).search(params[:q])
  end

  def self.default_limit(page_limit)
    if page_limit
      page_limit = 100 if page_limit > 100
    else
      page_limit = 20
    end
  end
end
