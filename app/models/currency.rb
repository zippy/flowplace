class Currency < ActiveRecord::Base
  Activity
  class State
    def initialize(states)
      @state = {}
      states.each {|s| @state[s.to_s] = nil}
    end
    def [](field_name)
      method_missing(field_name)
    end
    def []=(field_name,val)
      method_missing(field_name+'=',val)
    end
    def method_missing(method,*args)
      method = method.to_s
      if method =~ /(.*)=$/
        return @state[$1] = args[0]
      else
        return @state[method] if @state.has_key?(method)
      end
      super
    end
    def get_state
      @state
    end
  end
  
  require 'nokogiri'
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper
  validates_presence_of :name,:type,:steward_id
  validates_uniqueness_of :name

  has_many :currency_weal_links, :dependent => :destroy
  has_many :weals, :through => :currency_weal_links
  has_many :currency_accounts, :dependent => :destroy
  has_many :users, :through => :currency_accounts
  belongs_to :steward, :class_name => 'User', :foreign_key => :steward_id
  has_many :currency_activities, :as => :activityable
  
  @@types = []
  cattr_accessor :types
  
  API = {
    'icon' => String,
    'symbol' => String,
    'text_symbol' => String,
    'name' => String,
  }

  def self.humanize_type(type)
    return "" if type.nil?
    less_prefix = type[8..-1]
    return "" if less_prefix.nil?
    less_prefix.titleize
  end

  def api_name
    name
  end
  
  def api_symbol
    symbol.blank? ? '¤' : symbol
  end

  def api_icon
    icon_url.blank? ? '/images/currency_icon_generic.jpg' : icon_url
  end
  
  def spec(api_method)
    raise "no spec!"
  end

  def api_description
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    @xgfl.xpath(%Q|/game/description|).inner_html
  end
  
  def api_plays
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    plays = {}
    @xgfl.xpath(%Q|/game/plays/*|).to_a.each{|p| plays[p.attributes['name'].to_s] = {:player_classes => p.attributes['player_classes'].to_s}}
    plays
  end
  
  def api_play_fields(play)
    @play_fields ||= {}
    return @play_fields[play] if @play_fields[play]
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    @play_fields[play] = @xgfl.xpath(%Q|/game/plays/play[@name= "#{play}"]/fields/*|).to_a.collect do |f|
      attributes = {}
      f.attributes.each {|k,v| attributes[k] = v.to_s}
      {f.attributes["id"].to_s => attributes}
    end
  end

  def api_state_fields(player_class)
    @state_fields ||= {}
    return @state_fields if @state_fields[player_class]
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    player_state = @xgfl.xpath(%Q|/game/states/state[@player_class="#{player_class}"]/*|)
    @state_fields[player_class] = player_state.to_a.collect {|s| {s.attributes['name'].to_s => s.name.to_s}}
  end
  
  def api_configurable_fields
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    configurable_fields = {}
    @xgfl.xpath(%Q|/game/plays/*|).to_a.each do |play|
      play_name = play.attributes['name'].to_s
      play.xpath("fields/*").to_a.each do |f|
        if c = f.attributes['configure_with']
          configurable_fields["#{play_name}.#{f.attributes['id'].to_s}"] = c.to_s
          if d = f.attributes['default']
            configurable_fields["#{play_name}.#{f.attributes['id'].to_s}.default"] = d.to_s
          end
        end
      end
    end
    @xgfl.xpath(%Q|/game/states/state[@player_class="_"]/*|).to_a.each do |state|
      state_name = state.attributes['name'].to_s
      config_attributes = state.attributes['configure_with']
      if !config_attributes.nil?
        configurable_fields["_.#{state_name}"] = config_attributes.to_s
        if d = state.attributes['default']
          configurable_fields["_.#{state_name}.default"] = d.to_s
        end
      end
    end
    
    configurable_fields
  end

  def api_render_value(value)
    value
  end

  def api_render_player_state(account)
    s = account.get_state
    if s
      state = []
      s.keys.sort.each {|field| state.push "#{field.titleize}: #{s[field]}"}
      state.join('; ')
    end
  end

  def api_player_classes
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    @xgfl.xpath(%Q|/game/player_classes/*|).to_a.collect{|c| c.attributes['name'].to_s}
  end
  
  def api_play_sentence(play)
    @play_sentence ||= {}
    return @play_sentence[play] if @play_sentence[play]
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    ps = @xgfl.xpath(%Q|/game/plays/play[@name= "#{play}"]/play_sentence|).first
    raise "Error: play sentence not defined for #{play}" if ps.nil?
    @play_sentence[play]  = ps
  end

  def api_play_sentence_fields(play)
    sentence = api_play_sentence(play)
    fields = []
    sentence.children.each {|e| fields << e.name if e.is_a?(Nokogiri::XML::Element)}
    fields
  end
  
  def api_play_sentence_raw(play)
    api_play_sentence(play).inner_html
  end
  
  def api_play_sentence_fill(play)
    sentence = ""
    api_play_sentence(play).children.each do |element|
      case element
      when Nokogiri::XML::Text
        sentence += element.text
      when Nokogiri::XML::Element
        field_name = element.name
        result = yield(field_name)
        sentence += result
      else
        raise element.inspect
      end
    end
    sentence
  end

  def api_humanize_play(play)
    content = load_play_content(play)
    sentence = api_play_sentence_fill(content['__meta']['name']) do |field_name|
      case content[field_name]
      when Hash
        content[field_name]['_name']
      else
        content[field_name].to_s
      end
    end
  end
    
  def api_render_summary
     (total_plays,result) = scan_member_accounts
#    result = name+" has "
#    result += api_player_classes.collect {|player_class| cas = currency_accounts.find(:all,:conditions => ["player_class = ?",player_class]).size; "#{cas} #{(cas > 1 || cas < 1) ? player_class.pluralize : player_class}" }.join(' and ')
    result
  end
  
  def scan_member_accounts
    player_class = 'member'
    ca = currency_accounts.find(:all,:conditions => ["player_class = ?",player_class])
    total_plays = 0

    ca.each do |account|
      s = account.get_state
      if s
        total_plays += account.plays.size
        yield(s) if block_given?
      end
    end

    if total_plays > 0
      total_plays /= 2
      result = [
        "Total plays: #{total_plays}",
        "Average plays/member: #{sprintf("%.1f",total_plays.to_f/ca.size)}"
      ].join('<br />')
      [total_plays,result]
    else
      [0,'No Plays']
    end
  end
  
  def api_play_history(account)
    raw_plays = account.plays
    plays = []
    raw_plays.each do |play|
      content = load_play_content(play)
      content['__meta'] ||= {}
      content['__meta']['timestamp'] = play.created_at
      plays << content
    end
    plays
  end
  
  def load_play_content(play)
    if play.content.is_a?(String)
      begin
        YAML.load(play.content)
      rescue
        {"corrupted_play"=>play.content}
      end
    else
      play.content
    end
  end
  
  def api_play_field_names(play_name)
    api_play_fields(play_name).collect {|field| field.keys[0]}
  end
  
  def api_play_names(player_class)
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    play_names = []
    @xgfl.xpath(%Q|/game/plays/*|).to_a.each do |p|
      tpc = p.attributes['player_classes'].to_s
      classes = tpc.split(/, */)
      classes.each do |pc|
        if player_class == pc
          play_names << p.attributes['name'].to_s
        end
      end
    end
    play_names
  end
  
  def api_new_player(player_class,user,name = nil)
    opts = {:user_id => user.id,:name => name ? name : user.user_name,:currency_id => self.id,:player_class => player_class}
    ca = CurrencyAccount.new(opts)
    ca.setup
    ca.save
    ca
  end
  
  def api_initialize_new_player_state(player_class)
    s = Currency::State.new(api_state_fields(player_class).collect {|state| state.keys[0]})
    prepare_eval('setting state for new player') do
      eval "@#{player_class}_state = s"
    end
    
    script = get_play_script("_new_#{player_class}")
    if !script.blank?
      prepare_eval('new_player') do
        eval script
      end
    end
    s.get_state
  end
  
  def get_play_script(play_name)
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    script = @xgfl.xpath(%Q|/game/plays/play[@name= "#{play_name}"]/script/text()|).to_s
    if !script.blank?
      if script =~ /<\!\[CDATA\[(.*)\]\]>/m
        script = $1
      end
    end
    script
  end

  def api_user_accounts(player_class,user = nil)
    opts = ["currency_id = ? and player_class = ?",self.id,player_class]
    if !user.nil?
      opts[0]+= " and user_id = ?"
      opts.push user.id
    end
    CurrencyAccount.find(:all,:conditions => opts)
  end
  
  def api_user_isa?(user,player_class)
    !api_user_accounts(player_class,user).empty?
  end
  
  def setup_model(model,field_value)
    if field_value.is_a?(model)
      field_value
    else
      v = yield(field_value)
      raise "Unknown #{model.to_s.downcase}: #{field_value}" if v.nil?
      v
    end
  end
  
  def api_play(play_name,currency_account,play)
    @play = Currency::State.new(api_play_field_names(play_name))
    notification_players = {}
    api_play_fields(play_name).each do |field|
      field = field.values[0]
      field_name = field['id']
      field_type = field['type']
      case field_type
      when 'integer','string','text','range','play','options'
        @play[field_name] = play[field_name]
      when 'boolean'
        val = play[field_name]
        @play[field_name] = (val == 'true' || val == '1' || val == true) ? true : false
      when 'currency'
        @play[field_name] = setup_model(Currency,play[field_name]) { |name| Currency.find_by_name(name)}
      when 'user'
        @play[field_name] = setup_model(User,play[field_name]) { |name| User.find_by_user_name(name)}
      when /player_(.*)/
        player_class_string = $1
        player_classes = player_class_string.split(/, */)
        if play[field_name].blank?
          @play[field_name] = nil
        else
          @play[field_name] = play[field_name].get_state
          @play[field_name]['_name'] = play[field_name].name
          ca = play[field_name]
          notification_players[field_name] = ca
          ok = false
          player_classes.each do |player_class|
            ok = true if player_class == ca.player_class
          end
          raise "the player field '#{field_name}' in the #{play_name} play requires a player class of #{player_class_string}. Currency account #{ca.name} (id=#{ca.id}) is a #{ca.player_class}" unless ok
          @play[field_name]['_currency_account'] = ca
        end
      else
        raise "unknown field type: #{field_type}"
      end
    end
    
    script = get_play_script(play_name)
    
    return_value = #prepare_eval('play') do
      eval script
#    end
    if return_value == true
      stored_play = CurrencyAccount.transaction do
        currency_account_links = {}
        api_play_fields(play_name).each do |field|
          field = field.values[0]
          field_name = field['id']
          field_type = field['type']
          # save out the players state as it will have been updated by the play
          # but remove the spurious fields added in...
          case field_type
          when /player_(.*)/
            player_class = $1
            a = play[field_name]
            if a.is_a?(CurrencyAccount)
              p = @play[field_name]
              name = p['_name']
              p.delete('_name')
              currency_account_links[field_name] = p.delete('_currency_account')
              if !a.destroyed  #the currency account may just been destroyed by a revoke play
                a.state = p
                a.save
              end
              p['_name'] = name
            end
          end
        end
        content = @play.get_state
        content['__meta'] = {'name' => play_name,'currency_id'=>self.id}
        content['currency'] = content['currency'].name if content['currency'].is_a?(Currency)
        Play.transaction do
          p = Play.create!(:content=>content)
          currency_account_links.each do |field_name,account|
            PlayCurrencyAccountLink.create!(:currency_account_id => account.id, :play_id => p.id,:field_name => field_name)
            a = CurrencyActivity.add(account.user,self,{'play_id'=>p.id,'as'=>field_name})
          end
          p
        end
      end
      notification_players.each do |field_name,ca|
        if field_name != 'from' && ca.notification == 'email'
          params = {}
          params[:play_name] = play_name
          params[:currency] = self
          params[:from_currency_account] = currency_account
          params[:to_currency_account] = ca
          params[:play_text] = api_humanize_play(stored_play)            
          begin
            CurrencyNotificationMailer.deliver_currency_notification(params)
          rescue Exception => e
  #          return_value = "Could not deliver email: #{e}"
          end
        end
      end
      stored_play
    else
      if return_value.nil?
        raise "play script returned nil.  It should return true or an error string."
      end
      raise return_value
    end
  end
  
  def prepare_eval(context)
    begin
      yield
    rescue Exception => e
      raise "error executing #{context}.<br>Type: #{type}<br>#{e.inspect}<br> @play = #{@play.inspect} <br>"
    end
  end
  
  def method_missing(method,*args)
    #is this an attribute setter? or questioner?
    a = method.to_s
    if a =~ /^api_(.*?)$/
      api_method = $1
      raise "unknown API method" if !API[api_method] 
      spec(api_method)
    else
      super
    end
  end
  
  def name_as_html_id
    name.downcase.gsub(/\s+/,'_').gsub(/\W/,'X')
  end
  
  def humanized_type
    Currency.humanize_type(type)
  end

  def currency_accounts_total
    currency_accounts.size
  end
  
  def configuration=(c)
    self.config = configuration
    if c
      cf = api_configurable_fields
      c.keys.each do |field|
        if c[field].blank?
          config[field] = cf[field+".default"]
        else
          case cf[field]
          when 'integer'
            config[field] = c[field].to_i
          else
            config[field] = c[field]
          end
        end
      end
    end
  end

  def configuration
    case self.config
    when String
      self.config = YAML.load(self.config)
    when nil
      self.config = {}
      cf = api_configurable_fields
      cf.keys.each do |field|
        next if field =~ /\.default$/
        config[field] = cf[field+".default"]
        config[field] = config[field].to_i if cf[field] == 'integer'
      end
    end
    self.config
  end
  
end

XGFLDir = "#{RAILS_ROOT}/currencies"
if File.directory?(XGFLDir)
  currencies = []
  Dir.foreach(XGFLDir) do |file|
    if file =~ /(.*)\.xgfl$/
      currencies << $1
    end
  end
  currencies.each do |klass|
    file = XGFLDir+'/'+klass+'.xgfl'
    klass = "Currency"+klass.camelize
    Currency.types << klass
    file_contents = IO.read(file)
    new_class = <<-EORUBY
    class #{klass} < Currency
      def xgfl 
        <<-'EOXGFL'
#{file_contents}
        EOXGFL
      end
    end
    EORUBY
    eval new_class,nil,file
  end
end

#####################################################
# Here are flowpace specific overrides of the xgfl currencies

class CurrencyTrueGoodBeautiful
  def api_render_summary
    player_class = 'member'
    ca = currency_accounts.find(:all,:conditions => ["player_class = ?",player_class])
    t = g = b = 0
    total = 0
    ca.each do |account|
      s = account.get_state
      if s && s['true']
        total += 1
        t += s['true']; g += s['good']; b += s['beautiful']
      end
    end
    if total > 0
      "T:#{sprintf("%.1f",t.to_f/total)} G:#{sprintf("%.1f",(g).to_f/total)} B:#{sprintf("%.1f",(b).to_f/total)}"
    else
      'No Ratings'
    end
  end
  def api_render_player_state(account)
    s = account.get_state
    if s
      "T:#{s['true']} G:#{s['good']} B:#{s['beautiful']}"
    end
  end
end

module MutualCreditSummary
  def api_render_summary
    mass = 0
    (total_plays,result) = scan_member_accounts do |s|
      if s
        mass += s['balance'] if s['balance'] > 0
      end
    end
    result += "<br/ >Mass: #{mass}"
  end
end

class CurrencyMutualCreditBounded
  include MutualCreditSummary
  def api_render_player_state(account)
    if account.player_class == 'member'
      s = account.get_state
      if s
        "Balance: #{s['balance']}; Volume: #{s['volume']}; Plays: #{account.plays.size}; Limit: #{s['limit']}; "
      end
    else
      ""
    end
  end
end

class CurrencyMutualCredit
  include MutualCreditSummary
  def api_render_player_state(account)
    if account.player_class == 'member'
      s = account.get_state
      if s
        "Balance: #{s['balance']}; Volume: #{s['volume']}; Plays: #{account.plays.size}"
      end
    else
      ""
    end
  end
end

class CurrencyMutualRating
  def api_render_player_state(account)
    s = account.get_state
    if s
      rating = s['rating']
      if rating
        c = configuration['rate.rating'].split(/\W*,\W*/)
        rating = c[rating.round-1]
      end
      "My Rating: #{rating}"
    end
  end
end

class CurrencyAsymmetricAcknowledgement
  def api_render_summary
    inflow = 0
    outflow = 0
    (total_plays,result) = scan_member_accounts do |s|
      if s
        inflow += s['inflow']
        outflow += s['outflow']
      end
    end
    if total_plays > 0
      result += "<br/ >Average Inflow: #{sprintf("%.1f",inflow.to_f/total_plays)}"
      result += "<br/ >Average Outflow: #{sprintf("%.1f",outflow.to_f/total_plays)}"
    end
    result
  end
  def api_render_player_state(account)
    s = account.get_state
    if s
      result = "Inflow: #{s['inflow']}; Outflow: #{s['outflow']}"
      if !s['pending'].empty?
        pending_plays = s['pending'].collect do |play_id,value|
          (user,time) = play_id.split('|')
          p = s['pending'][play_id]
          "#{user} #{p['direction']} of #{p['memo']} at #{p['amount']}"
        end
        
        result += "<br />Pending:<br /> &nbsp;&nbsp;&nbsp;#{pending_plays.join('<br />&nbsp;&nbsp;&nbsp;')}"
      end
      result
    end
  end
end

class CurrencyMutualAcknowledgement
  def api_render_player_state(account)
    s = account.get_state
    if s
      result = "Balance: #{s['balance']}<br /> Volume: #{s['balance']}"
      if !s['pending'].empty?
        pending_plays = s['pending'].collect do |play_id,value|
          (user,time) = play_id.split('|')
          p = s['pending'][play_id]
          "#{user} acknowledgement of #{p['memo']} at #{p['amount']}"
        end
        
        result += "<br />Pending:<br /> &nbsp;&nbsp;&nbsp;#{pending_plays.join('<br />&nbsp;&nbsp;&nbsp;')}"
      end
      result
    end
  end
end

class CurrencyMutualCounting
  def api_render_summary
    get_counts
  end
  
  def api_render_player_state(account)
    result = ""
    c = configuration['_.countables']
    if c.nil?
      result += "<i>no countables defined</i>"
    else
      s = account.get_state
      if s
        result = "My Counts:"
        c.each do |name,vals|
          count = ((cr = s['counts_recorded']) && cr.has_key?(name)) ? cr[name].size : 0
          result += "<br /> &nbsp;&nbsp;&nbsp;#{name}: #{count}" 
        end
      end
    end
    result
  end
  def get_counts
    c = configuration['_.countables']
    result = "Counts:"
    if c.nil?
      result += "<br />&nbsp;&nbsp;&nbsp;<i>no countables defined</i>"
    else
      c.each do |name,vals|
        result += "<br /> &nbsp;&nbsp;&nbsp;#{name}: #{vals['count']}"
      end
    end
    result
  end
end

class CurrencyIntentions
  def get_types_as_configured
    types = {}
    configuration['declare.intention_type'].split(/\W*,\W*/).each {|t| types[t]=nil}
    types
  end
    
  def api_render_player_state(account)
#    types = get_types_as_configured
    types = {}
    s = account.get_state
    if s && !(i = s['intentions']).empty?
      result = ""
      i.each do |title,vals|
        types[vals['intention_type']] ||= []
        types[vals['intention_type']] << title
      end
      types.each do |t,v|
        if v.size > 0
          result += "#{t.pluralize.titleize}:"; v.each {|title| result += "<br /> &nbsp;&nbsp;&nbsp;#{title}" }
        end
      end
    else
      result = "<i>no intentions declared</i>"
    end
    result
  end
  
  def api_render_summary
    player_class = 'member'
    ca = currency_accounts.find(:all,:conditions => ["player_class = ?",player_class])
    types = {}#get_types_as_configured
    result = ""
    ca.each do |account|
      s = account.get_state
      if s && !(i = s['intentions']).empty?
        i.each do |title,vals|
          types[vals['intention_type']] ||= 0
          types[vals['intention_type']] += 1
        end
      end
    end
    types.each do |t,v|
      result += "<br /> #{v} #{ (v > 1 || v == 0) ? t.pluralize.titleize : t.titleize}"; 
    end
    result
  end
end

class CurrencyAcknowledgement
  def api_render_summary
    player_class = 'member'
    ca = currency_accounts.find(:all,:conditions => ["player_class = ?",player_class])
    given = 0
    received = 0
    ca.each do |account|
      s = account.get_state
      if s
        given += s['total_given']
        received += s['total_received']
      end
    end
    names = name.pluralize
    if ca.size > 0
      result = "Average #{names} Given: #{sprintf("%.2f",given.to_f/ca.size)}"
    else
      'No Plays'
    end
  end
  
  def api_render_player_state(account)
    s = account.get_state
    if s
      given = s['total_given']
      received = s['total_received']
      names = name.pluralize
      result = "Total #{names} Given: #{given}"
      recent_given = get_recent(s['acknowledgements_given'],"to")
      result << "<br>Recent #{names} Given: #{recent_given}" if !recent_given.blank?
      result << "<br>Total #{names} Received: #{received}"
      recent_received = get_recent(s['acknowledgements_received'],"from")
      result << "<br>Recent #{names} Received: #{recent_received}" if !recent_received.blank?
      result
    end
  end
  def get_recent(acks,direction)
    result = ""
    a_week_ago = Time.now - 7.days
    acks.keys.sort.reverse.each do |d|
      break if d.to_time < a_week_ago
      result << "<i>#{d}:</i> "
      
      acks[d].each do |to,ack|
        if to !~ /^_/
          result << "#{ack} #{direction} #{to}; "
        end
      end
    end
    result
  end
end


class CurrencyThanks
  include DateTimeRendering
  def api_render_summary
    given = received = 0
    (total_plays,result) = scan_member_accounts do |s|
      if s
        given += s['total_given'] if s['total_given']
        received += s['total_received'] if s['total_received']
      end
    end
    if total_plays > 0
      result += "<br/ >Average thanks given: #{sprintf("%.1f",given.to_f/total_plays)}"
#      result += "<br/ >Average thanks received: #{sprintf("%.1f",received.to_f/total_plays)}"
    end
    result
  end
  
  def api_render_player_state(account)
    s = account.get_state
    if s
      given = s['total_given']
      received = s['total_received']
      result = "Thanks given: #{given}; Thanks received: #{received}"
      recent = s['recent']
      if recent && recent.size > 0 
        result += "<br />Recent:"
        x = recent.keys.sort.reverse
        x.each {|t| result+= '<br />&nbsp;&nbsp;&nbsp;'+recent[t]+" on "+standard_date_time(Time.at(t))}
      end
      result
    end
  end
end

class CurrencyMembrane
  def self.create(namer_user,params)
    opts = {:steward_id => namer_user.id}.update(params[:circle])
    circle = CurrencyMembrane.new(opts)
    circle.type = 'CurrencyMembrane'
    
    if params[:password] != params[:confirmation]
      circle.errors.add_to_base("Passwords don't match")
    else
      circle_user = User.new({:user_name => circle.circle_user_name, :first_name => circle.name,:password => params[:password],:password_confirmation => params[:password],:last_name => "Circle",:email=>params[:email]})
      circle_user.circle = circle
      circle_user.skip_confirmation!
      if !circle_user.save
        circle.errors.add_to_base("Error creating circle user: "+ circle_user.errors.full_messages.join('; '))
      end
    end
    if circle.errors.empty? && circle.save
      self_player = circle.add_player_to_circle('self',circle_user)
      namer_player = circle.add_player_to_circle('namer',namer_user) if self_player
      binder_player = circle.add_player_to_circle('binder',namer_user) if self_player
    end
    if !circle.errors.empty?
      self_player.destroy if self_player
      namer_player.destroy if namer_player
      binder_player.destroy if binder_player
      circle_user.destroy if circle_user
      circle.destroy
    end
    circle
  end

  def autojoin_currencies
    self_player = currency_accounts.find_by_player_class('self')
    raise "missing self player for membrane currency" if self_player.nil?
    bound_currencies = get_self_state(self_player)
    result = []
    bound_currencies.keys.each do |k|
      if bound_currencies[k]['autojoin']
        c = nil
        begin
          c = Currency.find(k)
        rescue Exception => e
        end
        result.push(c) if c
      end
    end
    result
  end

  def circle_user_name
    name.tr(' ','_').downcase+'_circle'
  end

  # TODO we really ought to be adding members using the membrane 'name_user' play!!
  #if player_class == 'member'
  #  namer_currency_account = @circle.api_user_accounts('namer',current_user)[0]
  #  play = {
  #    'from' => namer_currency_account,
  #    'user' => user,
  #    'name' => user.user_name
  #  }
  #  @circle.api_play('name_user',namer_currency_account,play)
  #else
  #end
  def add_player_to_circle(player_class,user,namer = nil)
    player = api_new_player(player_class,user)
    if player.valid?
      if player_class == 'member' && namer
        self_player = currency_accounts.find_by_player_class('self')
        autojoin_currencies.each do |c|
          if !user.player_clasess_in(c).include?('member')
            play = {
              'from' => namer,
              'to' => player,
              'currency' => c,
              'player_class' => 'member'
            }
            api_play('grant',user,play)
          end
        end
      end
      player
    else
      self.errors.add_to_base("Error creating #{player_class} player for #{user.user_name}:"+player.errors.full_messages.join('; '))
      nil
    end
  end
  
  def get_self_state(self_account)
    currency_bindings = self_account.get_state['currencies']
    currency_bindings.keys.each {|k| currency_bindings[k] = {'name' => currency_bindings[k], 'autojoin' => true} if currency_bindings[k].is_a?(String) }
    currency_bindings
  end

  def currencies(get_full_info=false)
    @self = CurrencyAccount.find(:first, :conditions => ["name = ? and player_class = 'self'",circle_user_name])
    
    ####TODO remove this code!!  It's here to add in a self-player to circles that didn't have one
    # by accident
    if @self.nil?
      circle_user = User.find_by_user_name(self.circle_user_name)
      if circle_user.nil?
        circle_user = User.new({:user_name => self.circle_user_name, :first_name => self.name,:last_name => "Circle",:email=>'dummy@email.com'})
        circle_user.circle = self
        if !(circle_user.create_bolt_identity(:user_name => :user_name,:password => 'password') && circle_user.save)
          raise ("Error creating circle user: "+ circle_user.errors.full_messages.join('; '))
        end
      end
      @self = self.add_player_to_circle('self',circle_user)
    end
    ########
    
    #RESTORE THIS LINE
    #raise "Couldn't find self currency account for #{name}" if @self.nil?  
    currency_bindings = get_self_state(@self)
    currency_list = Currency.find(:all, :conditions => ['id in (?)',currency_bindings.keys])
    if get_full_info
      result = {}
      currency_list.each {|c| result[c.id] ={'currency'=> c,'autojoin'=>currency_bindings[c.id]['autojoin']}}
      result
    else
      currency_list
    end
  end

  def api_render_player_state(account)
    case account.player_class
    when 'member'
      s = account.get_state
      if s
        permissions = s['permissions']
        p = ""
        if permissions
          permissions.collect {|k,v| p+= "#{k}[#{v.keys.join('; ')}]"}.join(', ')
          "Perms: #{p}"
        else
          ''
        end
      end
    when 'inviter'
      s = account.get_state
      if s
        result = ''
        result += invite_helper(s['invitations'],'pending')
        result += invite_helper(s['invitations_accepted'],'accepted')
        result
      end
    when 'namer'
      "<i>Namer player state rendering not implemented</i>"
    when 'binder'
      "<i>Binder player state rendering not implemented</i>"
    end
  end
  
  def invite_helper(i,kind)
    result = ''
    if i
      count = i.size
      if count > 0
        result = ("#{count} #{kind} invitation:" + (count > 1 ? 's' : ''))
        i.each {|email,val| result += "<br /> &nbsp;&nbsp;&nbsp;#{email}#{kind == 'accepted' ? " (#{val})" : ''}" }
      end
    end
    result
  end
end


class CurrencyStars < Currency
  def api_input_html(field_id_prefix,value=nil)
		select_tag(field_id_prefix,options_for_select([["*", "1"], ["**", "2"], ["***", "3"], ["****", "4"]],value))
  end

  def api_render_value(value)
    "*"*value.to_i
  end

  def spec(api_method)
    {
      'icon' => '/images/currency_icon_stars.jpg',
      'symbol' => '*',
      'text_symbol' => '*',
      'name' => 'Stars',
    }[api_method]
  end
end
