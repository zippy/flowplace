class CurrencyAccount < ActiveRecord::Base
  belongs_to :currency
  belongs_to :user
  has_many :plays
  validates_presence_of :currency_id,:user_id,:player_class,:name
  validates_uniqueness_of :currency_id, :scope => [:name,:player_class]
  validates_uniqueness_of :name, :scope => [:currency_id,:player_class]

  def setup
    self.state = currency.api_new_player(player_class)
  end

  def get_state
    s = self.state
    self.state = YAML.load(s) if s.class == String
    self.state
  end
  
  def render_state
    currency.api_render_account_state(self)
  end

  def name_as_html_id
    name.downcase.gsub(/\s+/,'_').gsub(/\W/,'X')
  end

end
