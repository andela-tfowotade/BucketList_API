module MessageService
  def welcome_to
    "Welcome! Please sign up or login to continue."
  end

  def self.empty_bucketlist
    "No bucket list created yet."
  end

  def self.empty_item
    "No item created yet."
  end

  def self.bucketlist_delete
    "Bucket list deleted successfully!"
  end

  def self.item_delete
    "Item deleted successfully!"
  end

  def self.bucketlist_not_found
    "Bucket List not found"
  end

  def self.item_not_found
    "Item not found"
  end

  def self.unauthorized
    "Unauthorized access"
  end
end
