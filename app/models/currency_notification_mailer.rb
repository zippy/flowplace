class CurrencyNotificationMailer < ActionMailer::Base
  helper :application
  include ApplicationHelper
  def currency_notification(params)
    @currency = params[:currency]
    @from_currency_account = params[:from_currency_account]
    @to_currency_account = params[:to_currency_account]
    @play_name = params[:play_name]
    @play_text = params[:play_text]
    @site_name = configuration_text(:site_name)
    recipients @to_currency_account.user.email
    subject    "#{@site_name}: #{@play_name} play in #{@currency.name}"
    from       CONFIG[:sys_email_from]
    sent_on    Time.now
  end
end
