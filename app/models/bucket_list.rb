class BucketList < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :created_by, presence: true

  scope :paginate, lambda { |page, page_limit| 
    limit(page_limit).offset(page_limit.to_i * ([page.to_i, 1].max - 1)) 
  }

  scope :search, lambda { |q| where("name like ?", "%#{q}%") }

  def self.paginate_and_search(params)
    paginate(params[:page], params[:limit]).search(params[:q])
  end
end 
