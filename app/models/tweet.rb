class Tweet < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :content
  
  
  
  def self.feed(user)
    user_ids = Tweet.user_ids_for_feed(user)
    Tweet.where("user_id IN (?)", user_ids)
  end
  
  # grab a list of user ids of the people you are following
  # need to append yourself.
  # follower ----> followed
  def self.user_ids_for_feed(user)
    ids = Array.new
    
    # grab ids of the people you are following using the relationship
    user.relationships.find_each do |r|
      ids.push(r.followed_id)
    end
    
    # append youself.
    ids.push(user.id)
  end
  
end
