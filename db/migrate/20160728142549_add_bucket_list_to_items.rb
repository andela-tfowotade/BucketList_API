class AddBucketListToItems < ActiveRecord::Migration
  def change
    add_reference :items, :bucket_list, index: true, foreign_key: true
    remove_column :items, :bucketlist_id
  end
end
