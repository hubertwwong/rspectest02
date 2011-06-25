class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  # relationships.
  has_many :tweets
  
  # "following" == people you are tracking.
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  # "followers" == people who are tracking you.
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  
  # checks to see if a user is following another perosn.
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  # create a relationship to follow the specified userr.
  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end
  
  # removes the relationship.
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
  # search helper...
  def self.search_by_username(term)
    User.where("username like ?", '%' + term.to_s + '%')
  end
  
end