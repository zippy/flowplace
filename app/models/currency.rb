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
  validates_presence_of :name,:type
  validates_uniqueness_of :name

  belongs_to :circle
  has_many :currency_weal_links, :dependent => :destroy
  has_many :weals, :through => :currency_weal_links
  has_many :currency_accounts, :dependent => :destroy
  has_many :users, :through => :currency_accounts
  
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
    @play_sentence[play]  = ps.inner_html
  end

  def api_render_summary
#    summary
  end
  
  def api_render_play(play)
    if play.is_a?(String)
      play = YAML.load(play)
    end
    play.inspect
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

  def api_user_accounts(user,player_class)
    CurrencyAccount.find(:all,:conditions => ["user_id = ? and currency_id = ? and player_class = ?",user.id,self.id,player_class])
  end
  
  def api_user_isa?(user,player_class)
    !api_user_accounts(user,player_class).empty?
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
    @play = Currency::State.new(api_play_fields(play_name).collect {|field| field.keys[0]})
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
          @play[field_name]['_currency_account'] = play[field_name]
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
        api_play_fields(play_name).each do |field|
          field = field.values[0]
          field_name = field['id']
          field_type = field['type']
          case field_type
          when /player_(.*)/
            player_class = $1
            a = play[field_name]
            if a.is_a?(CurrencyAccount)
              a.state = @play[field_name]
              a.save
            end
          end
        end
        Play.create!(:content=>@play,:currency_account_id => currency_account.id)
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

  def humanized_scope
    if global
      "Global"
    elsif circle
      circle.name
    else
      ''
    end
  end
  
  def currency_accounts_total
    currency_accounts.size
  end
  
  def configuration=(c)
    self.config = c
  end

  def configuration
    if self.config.is_a?(String)
      self.config = YAML.load(self.config)
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

class CurrencyMembrane
  def self.create(matrice_user,params)
    circle = CurrencyMembrane.new(params[:circle])
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
      matrice_player = circle.add_player_to_circle('matrice',matrice_user) if self_player
    end
    if !circle.errors.empty?
      self_player.destroy if self_player
      matrice_player.destroy if matrice_player
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
  #  matrice_currency_account = @circle.api_user_accounts(current_user,'matrice')[0]
  #  play = {
  #    'from' => matrice_currency_account,
  #    'user' => user,
  #    'name' => user.user_name
  #  }
  #  @circle.api_play('name_user',matrice_currency_account,play)
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
    raise "Couldn't find self currency account for #{name}" if @self.nil?
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
