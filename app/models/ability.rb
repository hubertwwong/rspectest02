class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new     # guest user (not logged in)
    if user.id != nil     # checks if user is registered
      # for users. check if user_id == the same one in the model.
      can :manage, Tweet, :user_id => user.id
      can :manage, User, :id => user.id
      can :read, User
      # can :read, Relationship
      can :manage, Relationship#, :follower_id => user.id
      # so there is a bug that i can't figure out at this point...
      # basically if i limit relationship by follower_id i get some weird permission errors.
      # left commented out for now...
    else
      can :read, Tweet
      can :read, User
      can :read, Relationship
    end
  end
end
