module CurrenciesHelper
  def currency_types_list_for_select
    Currency.types.collect {|t| [Currency.humanize_type(t),t]}
  end
  def humanized_currency_scope(currency)
    result = ""
    result << currency.circle.name if currency.circle
    if currency.global
      result << '--' if !result.blank?
      result << "Global"
    end
    result
  end
end
