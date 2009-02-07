# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'lib/constants'
  require 'lib/sql'
  include DateTimeRendering

  def notice(note, param)
    case note
    when :user_activated
      "Activation instructions have been sent to #{param.email} for account #{param.user_name}."
    when :user_deactivated
      "Account #{param.user_name} was deactivated."
    when :user_activation_resent
      "Activation instructions have been re-sent to #{param.email} for account #{param.user_name}."
    when :password_reset
      "The password for #{param.user_name} was reset and an e-mail sent to #{param.email}"
    when :user_created
      "Account #{param.user_name} was created."
    when :user_deleted
      "Account #{param} was deleted."
    when :user_contact_info_updated
      param == current_user ? "Your contact information was updated." : "The contact info for account #{param.user_name} was updated."
    when :user_preferences_set
      param == current_user ? "Your preferences were updated." : "The preferences for account #{param.user_name} were updated."
    when :password_changed
      "Your password has been changed."
    when :session_expired
      "Your session has timed out. Please sign in again to continue."
    when :not_allowed
      "You don't have permission to do that."
    else
      note.to_s
    end
  end

  def set_prefs_url
    url_for(:controller => 'users', :action => 'preferences', :id => current_user.id)
  end
  def set_password_url
    url_for(:controller => 'users', :action => 'password', :id => current_user.id)
  end
  def set_contact_info_url
    url_for(:controller => 'users', :action => 'contact_info', :id => current_user.id)
  end
  def showable_note(title,note,css_class='note_box')
    id = title.hash.to_s
    <<-EOHTML
    <div>
    #{link_to_function "#{title}",visual_effect(:toggle_blind,id,:duration => 0.5)}
    <div id="#{id}" style="display: none;" class="#{css_class}">#{note}
    </div>
    </div>
    EOHTML
  end
  def localize_time(the_time)
    standard_time(current_user.localize_time(the_time))
  end
  def nav_link(text,url,title)
    options = {:title => title}
    options[:class] = 'active' if case text
    when 'Circles'
      request.path =~ /^\/circles/
    when 'Currencies'
      request.path =~ /^\/currencies/
    when 'Dashboard'
      request.path == '/'
    when 'Intentions'
      request.path =~ /^\/intentions/
    when 'Match!'
      request.path =~ /^\/weals/
    when 'Accounts'
      request.path =~ /^\/users/
    when 'Admin'
      request.path =~ /^\/admin/
    end
    link_to text,url,options
  end
  def gravitar_image_tag(user,options = {:size=>32})
    image_tag user.gravatar_url(options),:class=>'gravitar'
  end
end
