class BucketList < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :created_by, presence: true

  scope :paginate, lambda { |page, page_limit| 
    limit(page_limit).offset(page_limit.to_i * ([page.to_i, 1].max - 1)) 
  }
end 
