class Database < Thor
  
  desc "populate", "load some sameple database data into the dev db."
  def populate
  	init_rails
  	db_reset
  	
  	# settings
  	num_users = 20
  	num_tweets = 20
  	user_name = "faker"
  	user_email = "faker"
  	user_email_domain = "fake.org"
  	
    puts "populate"
    make_users(num_users, user_name, user_email, user_email_domain)
    make_tweets(num_users, num_tweets, user_name)
    make_relationships(num_users, user_name)
  end
  
  private
  
  def make_users(num_users, user_name, user_email, user_email_domain)
  	puts "making users"
  	
  	num_users.times do |n|
	  username  = user_name + n.to_s
	  email = user_email + n.to_s + "@" + user_email_domain
	  password  = "password"
	  User.create!(:username => username,
	               :email => email,
	               :password => password,
	               :password_confirmation => password)
  	end
  end
  
  def make_tweets(num_users, num_tweets, user_name)
  	puts "making tweets"
  	
  	num_users.times do |n|
  	  # fetch user n..
	  u = User.where(:username => user_name + n.to_s).first
	  
	  # generate sequential tweets.
	  # also tweets are offset by a day.
	  num_tweets.times do |t|
	    tweet = "tweet " + t.to_s + " by " + user_name + n.to_s
	  	u.tweets.create(:content => tweet, :created_at => (Time.now.utc - t.days), :updated_at => (Time.now.utc - t.days))
	  end
  	end
  end
  
  def make_relationships(num_users, user_name)
  	puts "making relationships"
  	
  	num_users.times do |n|
  	  # fetch user n..
	  u = User.where(:username => user_name + n.to_s).first
	  #puts u.username
	  
	  # set up relationhips...
	  # each user will follow all users up to the n
	  # so user 1 follows 2,3,4
	  # user 2 followers 3,4....
	  (n + 1).upto (num_users - 1) do |m|
	  	u2 = User.where(:username => user_name + m.to_s).first
	  	Relationship.create(:follower_id => u.id, :followed_id => u2.id)
	  	#puts "> " + u2.username
	  end
  	end
  end
  
  # allows thor to access rails
  def init_rails
  	require './config/environment'
  end
  
  # db reset.
  def db_reset
  	system("rake db:drop")
	system("rake db:create")
	system("rake db:migrate")
	system("rake db:test:prepare")
  end
  
end