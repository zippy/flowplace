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
      request.path =~ /^\/my_currencies/
    when 'My Wealth Stream'
      request.path == '/'
    when 'Intentions'
      request.path =~ /^\/intentions/
    when 'Match!'
      request.path =~ /^\/weals/
    when 'Accounts'
      request.path =~ /^\/users/
    when 'Admin'
      request.path =~ /^\/admin/
    when 'Wallets'
      request.path =~ /^\/wallets/
    end
    link_to text,url,options
  end
  def gravitar_image_tag(user,options={})
    options[:size] ||= 32
    size = options[:size]
    image_tag user.gravatar_url(options),:class=>'gravitar',:size=>"#{size}x#{size}",:title => "#{current_user.full_name} (#{current_user.user_name})"
  end
  
  def users_select_tag(users,opts={})
    select_tag(:user_id, options_for_select_users(users), opts)
  end
  def options_for_select_users(users)
    options_for_select([['-','']] + users.collect{|u| [u.full_name,u.id]})
  end
  
  def render_currency_icon(currency,size=20)
    image_tag currency.api_icon, :height=>size, :width=>size
  end

  def currencies_list_for_select(currencies)
    currencies.collect {|p| [ p.name, p.id ] }
  end

  def wallet_list_for_select(user)
    wallets = [user.user_name]
    prefix = user.user_name
    if !user.wallets.empty?
      wallets + user.wallets.collect {|w| "#{prefix}.#{w.name}" }
    end
  end

  def currency_accounts(currency,opts={})
    if opts[:player_class]
      accounts = currency.currency_accounts.find(:all,:conditions=>["player_class = ?",opts[:player_class].to_s])
    else
      accounts = currency.currency_accounts
    end
    if opts[:exclude]
      accounts.delete_if {|a| a == opts[:exclude]}
    end
    accounts
  end
  def currency_accounts_select(currency,id,opts)
    select_tag(id, options_for_select(currency_accounts(currency,opts).collect {|a| [ a.name, a.id ] }), :include_blank => true)
  end
  
  def render_play_form(currency,currency_account)
    exclude_list = ['from','to']
    play_name = ''
    case currency
    when CurrencyMutualCredit
      play_name = 'payment'
      exclude_list << 'aggregator'
    when CurrencyIssued
      play_name = 'payment'
    when CurrencySocialCapital
      play_name = 'rate'
    when CurrencyTracked
      play_name = 'payment'
    end
    <<-EOHTML
    <fieldset>
    <legend>
      <label for="user_id">Make a play with:</label>
      #{currency_accounts_select(currency,'play[to]',:exclude => currency_account)}
    </legend>
      #{currency_play_html(currency,currency_account,play_name,:field_id_prefix=>'play',:exclude=>exclude_list)}
      #{submit_tag 'Record Play'}
    </fieldset>
    EOHTML
  end
  
  def currency_play_html(currency,currency_account,play,opts={})
    options = {
      :field_id_prefix => '',
      :exclude => [],
    }.update(opts)
    field_id_prefix = options[:field_id_prefix]
    exclude_list = options[:exclude]
    accounts = currency_accounts(currency).collect {|a| [ a.name, a.id ] }
    results = []
    currency.api_play_fields(play).each do |field|
      field_name = field.keys[0]
      next if exclude_list.include?(field_name)
      field_type = field.values[0]
      if field_id_prefix.blank?
        html_id = html_name = field_name
      else
        html_id = "#{field_id_prefix}_#{field_name}"
        html_name = "#{field_id_prefix}[#{field_name}]"
      end
      case field_type
      when 'integer','string','float'
        results.push %Q|<label for="#{html_id}">#{field_name.titleize}:</label>#{text_field_tag(html_name)}|
      when 'text'
        results.push %Q|<label for="#{html_id}">#{field_name.titleize}:</label>#{text_area_tag(html_name)}|
      when /player_(.*)/
        player_class = $1
        results.push %Q|<label for="#{html_id}">#{field_name.titleize}:</label>|+currency_accounts_select(currency,html_name,:exclude=>currency_account,:player_class=>player_class)
      end
    end
    results.join('<br />')+%Q|<input type="hidden" name="play_name" value="#{play}">|
  end

end
