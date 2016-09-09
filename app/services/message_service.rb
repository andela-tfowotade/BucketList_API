class MessageService
  def self.bucketlist_empty
    "No bucket list created yet."
  end

  def self.invalid_attributes
    "Invalid Username/Password"
  end

  def self.logout_success
    "Log out successful!"
  end

  def self.user_not_found
    "User not found! Sign up to continue"
  end

  def self.user_created
    "User created successfully!"
  end

  def self.welcome
    "Welcome! Please Sign up or login to continue."
  end

  def self.bucketlist_deleted
    "Bucket list deleted successfully!"
  end

  def self.unauthorized
    "Unauthorized access"
  end

  def self.no_item
    "No item created yet."
  end

  def self.item_deleted
    "Item deleted successfully!"
  end

  def self.unauthenticated
    "Authorization token not found!"
  end

  def self.logged_out
    "You're logged out! Please login to continue."
  end
end
