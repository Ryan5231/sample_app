class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relations, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relations, source: :followed
  has_many :reverse_relations, foreign_key: "followed_id", 
                               class_name: "Relation",
                               dependent: :destroy
  has_many :followers, through: :reverse_relations, source: :follower
  
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token 
  
  validates :name, presence: true, length: {maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  validates :password, length: {minimum: 6}
  validates :password_confirmation, presence: true
  
  def following?(other_user)
    relations.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relations.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relations.find_by_followed_id(other_user.id).destroy
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
