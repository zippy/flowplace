class Ability
  include CanCan::Ability
  
  def initialize(user)
    @user = user || User.new # guest user
    
    @user.get_privs.each{|p| can p.to_sym,:all}
    if @user.has_priv?(:admin)
    end
  end
end