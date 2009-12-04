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
  
  def get_index_form_html(params,url)
    form_tag(url,:method => :get, :id => 'search_form') do 
       get_search_form_html(params)
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
  
  def nav_link(text,path,title,active_path = nil)
    options = {:title => title}
    if active_path.nil?
      if path =~ /(\/[^\/]+)/
        active_path = $1
      end
    end
    if (!active_path.blank? && request.path =~ /^#{active_path}/) || (path == '/' && request.path == '/')
      options[:class] = 'active' 
    end
    link_to text,path,options
  end

  def sub_nav_link(text,path,title)
    options = {:title => title}
    if request.path == path
      options[:class] = 'active' 
    end
    link_to text,path,options
  end

  def gravitar_image_tag(user,options={})
    options[:size] ||= 32
    size = options[:size]
    link_to image_tag(user.gravatar_url(options),:class=>'gravitar',:size=>"#{size}x#{size}",:title => "#{user.full_name} (#{user.user_name})"),"/?user_id=#{user.id}"
  end
  
  def users_select_tag(users,opts={})
    select_tag(:user_id, options_for_select_users(users), opts)
  end
  def options_for_select_users(users)
    options_for_select([['-','']] + users.collect{|u| [u.full_name,u.id]})
  end
  
  def my_circles_jump_select(include_blank = false)
    select_tag('current_circle',options_for_select(my_circles_for_select(include_blank),@current_circle))
  end
  def my_circles_for_select(include_blank = false)
    @my_circles ||= current_user.circle_memberships
    result = @my_circles.collect {|c| [c.name,c.id]}
    result = [['-',nil]].concat(result) if include_blank
    result
  end
  
  def render_currency_icon(currency,size=20)
    image_tag currency.api_icon, :height=>size, :width=>size, :title=> "#{currency.name}: #{currency.description}"
  end

  def humanize_currencies(currencies)
    currencies.collect {|c| render_currency_icon(c)}.join(' ')
  end

  def currencies_list_for_select(currencies)
    currencies.collect {|c| [ standard_currency_description(c), c.id ] }
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
  
  def render_play_form(currency,currency_account,play_name)
    player_class = currency_account.player_class
    exclude_list = []#['from','to']
    plays = currency.api_plays
    raise "#{play_name} doesn't exist" if !plays.has_key?(play_name)
    raise "#{player_class} cannot make the #{play_name} play" if plays[play_name][:player_classes] != player_class
    case currency
    when CurrencyMutualCredit
      exclude_list << 'aggregator'
    when CurrencyIssued
    when CurrencySocialCapital
    when CurrencyTracked
      exclude_list << 'aggregator'
    end
    case play_name
    when 'pay'
      with_player_class = currency.class == CurrencyIssued ? 'user' : 'member'
    when 'issue'
      with_player_class = 'user'
    when 'retire'
      with_player_class = 'user'
    end
      
    form_tag(record_play_currency_account_path(currency_account),:id => play_name) +
      <<-EOHTML
      <fieldset>
        #{currency_play_html(currency,currency_account,play_name,:field_id_prefix=>'play',:exclude=>exclude_list)}
        #{submit_tag 'Record Play'}
      </fieldset>
      </form>
      EOHTML
  end
  
# <legend>
#   <label for="user_id">#{play_name.titleize}: </label>
#   #{currency_accounts_select(currency,'play[to]',:exclude => currency_account,:player_class => with_player_class)}
# </legend>
  
  def currency_play_html(currency,currency_account,play,opts={})
    options = {
      :field_id_prefix => '',
      :exclude => [],
    }.update(opts)
    field_id_prefix = options[:field_id_prefix]
    exclude_list = options[:exclude]
    accounts = currency_accounts(currency).collect {|a| [ a.name, a.id ] }
    results = []
    
    fields = {}
    currency.api_play_fields(play).each {|f| fields.update(f)}
    sentence = currency.api_play_sentence(play)
    #TODO: we need to make this actually work by XML not strings as this broke once allready when
    # the nokogiri library converted the play sentence to slightly different XML.
    sentence = sentence.gsub(/(<([^>]+) *\/>)|(<([^>]+)><\/\4>)/) do |field_name|
      field_name = $2
      field_name ||= $4
      next if exclude_list.include?(field_name)
      raise "unknown field '#{field_name}'" if fields[field_name].nil?
      field_type = fields[field_name]['type']
      if field_id_prefix.blank?
        html_id = html_name = field_name
      else
        html_id = "#{field_id_prefix}_#{field_name}"
        html_name = "#{field_id_prefix}[#{field_name}]"
      end
      case field_type
      when 'integer','float'
        result = text_field_tag(html_name,'',:size=>4)
      when 'string'
        result = text_field_tag(html_name,'',:size=>30)
      when 'range'
        case fields[field_name]['configure_with']
        when 'enumerable_range'
          r = enumerable_range_to_options_array(currency.configuration["#{play}.#{field_name}"])
        else
          r = (fields[field_name]['start']..fields[field_name]['end']).to_a
        end
        
        result = select_tag(html_name, options_for_select([nil].concat(r)))
      when 'text'
        result = text_area_tag(html_name)
      when 'currency'
        r = [nil].concat Currency.all.map(&:name)
        result = select_tag(html_name, options_for_select(r))        
      when 'user'
        r = [nil].concat User.all.map(&:user_name)
        result = select_tag(html_name, options_for_select(r))        
      when /player_(.*)/
        if field_name == "from"  #from is allways hard-coded to be current user and gets set in currency_accounts_controller when the play is made.
          result = currency_account.name
        else
          player_class = $1
          result = currency_accounts_select(currency,html_name,:exclude=>currency_account,:player_class=>player_class)
        end
      else
        result = "--UNKNOW FIELD TYPE: #{field_type}--"
      end
      result
    end
    return sentence+%Q|<input type="hidden" name="play_name" value="#{play}">|
    
    currency.api_play_fields(play).each do |field|
      field_name = field['id']
      next if exclude_list.include?(field_name)
      field_type = field['type']
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
  
  def enumerable_range_to_options_array(configuration_string)
    c = configuration_string.split(/\W*,\W*/)
    i = 0;
    c.collect {|e| [e,i+=1]}
  end
  
  
  def standard_currency_description(currency,include_icon = false)
    text = "#{currency.name}: #{currency.description}"
    text = "#{render_currency_icon(currency)} #{text}" if include_icon
    if block_given?
      yield text
    else
      text
    end
  end
  
  def activity_resource_url(activity)
    resource = activity.activityable
    if resource.nil?
      raise "resource doesn't exist"
    else
      case activity
      when IntentionActivity
        weal = resource
        weal.created_by == current_user ? edit_intention_url(weal) : intention_url(weal)
      when CircleActivity
        circle = resource
        circle_path(circle)
      else
        polymorphic_url(resource)
      end
    end
  end

  def subtab(tab,path)
    if request.path == path
      "<p>#{tab}</p>"
    else
      link_to tab, path
    end
  end
  def playtab(play_name,currency_account)
    path = play_currency_account_path(currency_account)+"?name=#{play_name}"
    if play_name == @play_name
      "<p>#{play_name.titleize}</p>"
    else
      link_to play_name.titleize, path
    end
  end
end
