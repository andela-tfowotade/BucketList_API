class AddUserToBucketLists < ActiveRecord::Migration
  def change
    add_reference :bucket_lists, :user, index: true, foreign_key: true
  end
end
