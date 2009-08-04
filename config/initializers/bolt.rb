Bolt::Initializer.run do |bolt|
  bolt.application_name = 'Flowplace'
  bolt.email_from = 'Flowplace <eric@harris-braun.com>'
  bolt.min_password_length = 4
  bolt.user_name_label = "Account Name"
  bolt.forgery_secret = "kasjdf908klasdjf89asdfkjsdf"
  bolt.after_logout_url = '/logged_out'
  bolt.user_model_email_attribute = 'email'
  bolt.password_error_message = 'Passwords must be at least 4 characters long'
  bolt.render_template_after_password_reset_email = 'passwords/reset_email_sent'
  bolt.password_change_notice = :password_changed
  bolt.session_expiration_time = SessionExpirationSeconds
  bolt.session_expiration_notice = :session_expired
end