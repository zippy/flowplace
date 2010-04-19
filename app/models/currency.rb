class Currency < ActiveRecord::Base
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
      configurable_fields["_.#{state_name}"] = state.attributes['configure_with'].to_s
      if d = state.attributes['default']
        configurable_fields["_.#{state_name}.default"] = d.to_s
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

  def api_render_summary
#    summary
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
        play = YAML.load(play.content)
      rescue
        play = {"corrupted_play"=>play.content}
      end
    end
    play
  end
  
  def api_play_field_names(play_name)
    api_play_fields(play_name).collect {|field| field.keys[0]}
  end
  
  def api_play_names(player_class)
    @xgfl ||= Nokogiri::XML.parse(xgfl)
    play_names = []
    @xgfl.xpath(%Q|/game/plays/*|).to_a.each do |p|
      pc = p.attributes['player_classes'].to_s
      if player_class == pc
        play_names << p.attributes['name'].to_s
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
      raise "Unknown #{model.to_s.downcase}: #{c}" if v.nil?
      v
    end
  end
  
  def api_play(play_name,currency_account,play)
    @play = Currency::State.new(api_play_field_names(play_name))
    api_play_fields(play_name).each do |field|
      field = field.values[0]
      field_name = field['id']
      field_type = field['type']
      case field_type
      when 'integer','string','text','range'
        @play[field_name] = play[field_name]
      when 'currency'
        @play[field_name] = setup_model(Currency,play[field_name]) { |name| Currency.find_by_name(name)}
      when 'user'
        @play[field_name] = setup_model(User,play[field_name]) { |name| User.find_by_user_name(name)}
      when /player_(.*)/
        player_class = $1
        if play[field_name].blank?
          @play[field_name] = nil
        else
          @play[field_name] = play[field_name].get_state
          @play[field_name]['_name'] = play[field_name].name
          ca = play[field_name]
          raise "currency account #{ca.name} (id=#{ca.id}) is a #{ca.player_class} not a #{player_class} as required for '#{field_name}' field in the #{play_name} play" if player_class != ca.player_class
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
      CurrencyAccount.transaction do
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
          end
          p
        end
      end
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
  def api_render_player_state(account)
    s = account.get_state
    if s
      "T:#{s['true']} G:#{s['good']} B:#{s['beautiful']}"
    end
  end
end

class CurrencyMutualCreditBounded
  def api_render_player_state(account)
    if account.player_class == 'member'
      s = account.get_state
      if s
        "Balance: #{s['balance']}; Volume: #{s['volume']}; Limit: #{s['limit']}; "
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

class CurrencyAcknowledgement
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
      acks[d].each do |to,acks|
        if to !~ /^_/
          result << "#{acks} #{direction} #{to}; "
        end
      end
    end
    result
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
      circle_user = User.new({:user_name => circle.circle_user_name, :first_name => circle.name,:last_name => "Circle",:email=>params[:email]})
      circle_user.circle = circle
      if !(circle_user.create_bolt_identity(:user_name => :user_name,:password => params[:password]) && circle_user.save)
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
  def add_player_to_circle(player_class,user)
    player = api_new_player(player_class,user)
    if player.valid?
      player
    else
      self.errors.add_to_base("Error creating #{player_class} player for #{user.user_name}:"+player.errors.full_messages.join('; '))
      nil
    end
  end

  def currencies
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
    Currency.find(:all, :conditions => ['id in (?)',@self.get_state['currencies'].keys])
  end

  def api_render_player_state(account)
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
