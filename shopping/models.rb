require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class Cart < ActiveRecord::Base
  has_many :cart_items 
  has_many :items, through: :cart_items
  belongs_to :user
end

class Item < ActiveRecord::Base
  belongs_to :category 
  has_many :cart_items 
  has_many :reviews 
  has_many :carts, through: :cart_items 
  has_many :favorites
end

class CartItem < ActiveRecord::Base
  belongs_to :cart 
  belongs_to :item
end

class Category < ActiveRecord::Base
  has_many :items 
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :favorites
  has_many :reviews 
  belongs_to :mode
  has_many :purchases
  has_many :carts 
end

class Favorite < ActiveRecord::Base 
  belongs_to :user 
  belongs_to :item
end 

class Review < ActiveRecord::Base
  belongs_to :users
  belongs_to :item
end 


class Mode < ActiveRecord::Base 
  has_many :users
end 

class Purchase < ActiveRecord::Base
  belongs_to :user
end 