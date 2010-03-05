module CurrencyAccountsHelper
  def get_play_data_for_display(currency,play,play_name)
    result = {}
    currency.api_play_fields(play_name).each do |field|
      field = field.values[0]
      field_name = field['id']
      field_type = field['type']
      case field_type
      when /player_(.*)/
        player_state = play[field_name]
        if player_state
          account_name = player_state['_name'] 
          result[field_name] = account_name
        end
      else
        result[field_name] = play[field_name]
      end
    end
    result
  end
end
