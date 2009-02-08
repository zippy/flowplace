class Currency < ActiveRecord::Base
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper
  validates_presence_of :name
  validates_uniqueness_of :name

  belongs_to :circle
  has_many :currency_weal_links, :dependent => :destroy
  has_many :weals, :through => :currency_weal_links
  has_many :currency_accounts, :dependent => :destroy
  
  API = {
    'icon' => String,
    'symbol' => String,
    'text_symbol' => String,
    'name' => String,
  }
  Types = [['USD','CurrencyUSD'],['WE','CurrencyWE'],['Star Reputation','CurrencyStars']]
  def spec(api_method)
    raise "no spec!"
  end
  
  def api_input_html(field_id_prefix,value=nil)
		text_field_tag(field_id_prefix,value,:size=>4)
  end

  def api_render_value(value)
    value
  end

  def api_render_account_summary(account)
    account.summary
  end

  def api_render_summary
    summary
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
