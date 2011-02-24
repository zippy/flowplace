class MyDeviseMailer < DeviseMailer
  private

    # Configure default email options
    def setup_mail(records, key)
      if records.is_a?(Array)
        record = records[0]
      else
        record = records
      end

      scope_name = Devise::Mapping.find_scope!(record)
      mapping    = Devise.mappings[scope_name]

      subject      translate(mapping, key)
      from         mailer_sender(mapping)
      recipients   record.email
      sent_on      Time.now
      content_type Devise.mailer_content_type
      body         render_with_scope(key, mapping, mapping.name => record, :resource => records)
    end
end