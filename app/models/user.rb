class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :bucket_lists, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
end
