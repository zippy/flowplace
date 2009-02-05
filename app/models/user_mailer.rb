class UserMailer < ActionMailer::Base
  
  def user(params)
    recipients params[:to_email]
    subject    params[:subject]
    from       "#{params[:from_email]} (#{params[:from_name]})"
    sent_on    Time.now
    
    body  params[:body]
  end

end
