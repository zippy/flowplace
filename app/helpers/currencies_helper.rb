module CurrenciesHelper
  def currency_types_list_for_select(exclude_list = [])
    (Currency.types-exclude_list).collect {|t| [Currency.humanize_type(t),t]}
  end
  def configurable_fields_html(currency)
    fields = currency.api_configurable_fields
    result = []
    c = currency.configuration
    current_play = ""
    fields.keys.sort.each do |field|
      field =~ /^([^.]*?)\.(.*?)(\.default)*$/
      next if $3
      if $1 != current_play
        current_play = $1
        if current_play == '_'
          result << "<br /><b>For currency as a whole:</b>"
        else
          result << "<br /><b>For #{current_play} play:</b>"
        end
      end
      field_name = $2
      id = "config[#{field}]"
      case fields[field]
      when 'enumerable_range','enumeration'
        extra = ": a comma separated list of choices"
      when 'integer'
        fsize = 5
      else
        raise fields[field].inspect
      end
      result << <<-EOHTML
      <p>
        #{label_tag id,field_name}: 
        #{text_field_tag id, c[field],:size=>fsize}(#{fields[field]}#{extra})
      </p>
      EOHTML
    end
    if result.empty?
      nil
    else
      %Q|<div id="configurable_fields">#{result}</div>|
    end
  end
end
