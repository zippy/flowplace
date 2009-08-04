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
  validates_presence_of :name
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

  def api_render_value(value)
    value
  end

  def api_render_account_state(account)
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
    @play_sentence[play]  = @xgfl.xpath(%Q|/game/plays/play[@name= "#{play}"]/play_sentence|).first.inner_html
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
  
  def api_new_player(player_class)
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
  
  def api_play(play_name,currency_account,play)
    @play = Currency::State.new(api_play_fields(play_name).collect {|field| field.keys[0]})
    api_play_fields(play_name).each do |field|
      field = field.values[0]
      field_name = field['id']
      field_type = field['type']
      case field_type
      when 'integer','string','text','range'
        @play[field_name] = play[field_name]
      when /player_(.*)/
        player_class = $1
        @play[field_name] = play[field_name].blank? ? nil : play[field_name].get_state
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
        <<-EOXGFL
#{file_contents}
        EOXGFL
      end
    end
    EORUBY
    eval new_class,nil,file
  end
end

class CurrencyUSD < Currency
  def spec(api_method)
    {
      'icon' => '/images/currency_icon_usd.jpg',
      'symbol' => '$',
      'text_symbol' => 'USD',
      'name' => 'Dollar',
    }[api_method]
  end
end

class CurrencyWE < Currency
  def spec(api_method)
    {
      'icon' => '/images/currency_icon_we.jpg',
      'symbol' => 'WE',
      'text_symbol' => 'WE',
      'name' => 'WE',
    }[api_method]
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
