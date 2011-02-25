class Ability
  include CanCan::Ability
  
  def initialize(user)
    @user = user || User.new # guest user
    
    @user.get_privs.each{|p| can p.to_sym,:all}
    if @user.has_priv?(:admin)
      can :read, :logged_in_users
      can :login_as, User
      can :delete, User
      can :read, :sys_info
      can :merge_default, Configuration
      can :read, Configuration
      can :edit, Configuration
      can :create, Configuration
      can :change_password, User
    end
    if @user.has_priv?(:accessAccounts)
      can :read, User
      can :edit, User
    end
    if @user.has_priv?(:createAccounts)
      can :create, User
    end
    if @user.has_priv?(:admin_annotations)
      can :delete, Annotation
    end
    if @user.has_priv?(:view_annotations)
      can :read, Annotation
    end
    if @user.has_priv?(:edit_annotations)
      can :read, Annotation
      can :edit, Annotation
      can :create, Annotation
    end
    if @user.has_priv?(:circle)
      can :edit, :circle
      can :create, :circle
      can :delete, :circle
    end
    if @user.new_record?
      can :self_signup, :all if  Configuration.get(:new_user_policy) == 'self_signup'
    else
      can :change_password, User
      can :read, :circle
    end
  end
end