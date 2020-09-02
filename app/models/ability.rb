class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    
    if user.admin?
      
      # Users
      ############
      can :manage, User do |user_record|
        user.company == user_record.company
      end
      can :create, User
      
      # Companies
      ############
      can :manage, Company do |company|
        user.company == company
      end
      
      # Images
      ############
      can :index, Image
      
      # Shipments
      ############
      can :index, Shipment
      
      # Searches
      ############
      can :manage, Search do |search|
        user.company == search.user.company
      end
      can :index, Search
      
      # Cameras
      can :manage, Camera
      
      # Signatures
      ############
#      can :manage, Signature
#      can :create, Signature
      
    elsif user.external?
      
      # Users
      ############
      can :manage, User do |user_record|
        user == user_record
      end
      
      # Images
      ############
      can :index, Image if user.images?
      
      # Shipments
      ############
      can :index, Shipment if user.shipments?
      
    elsif user.basic?
      
    end
    
  end
end
