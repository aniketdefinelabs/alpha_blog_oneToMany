class User < ApplicationRecord
  has_many :articles
  has_secure_password
  has_one_attached :profile_picture
end
