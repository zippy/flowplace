module UsersHelper
  include Lister
  def country_options_for_select
    CountryOptions
  end
end
