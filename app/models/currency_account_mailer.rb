class CurrencyAccountMailer < ActionMailer::Base
  helper :application
  include ApplicationHelper
  def circle_invitation(params)
    @currency_account = params[:currency_account]
    @params  = params
    @site_name = configuration_text(:site_name)
    recipients params[:to_email]
    subject    "Invitation to join the #{@site_name} circle: #{params[:circle]}"
    from       "#{@currency_account.user.email} (#{@currency_account.user.full_name})"
    sent_on    Time.now
  end

end
