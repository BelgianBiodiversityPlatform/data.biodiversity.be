class ContactMailer < ActionMailer::Base
  
  def contact_email(params)
    recipients  CONTACT_EMAIL_RECIPENTS
    from        params[:sender_address]
    subject     "[Message posted through #{APP_NAME}]"
    sent_on     Time.now
    body        ({  :name =>    params[:sender_name],
                    :address => params[:sender_address],
                    :title =>   params[:message_title],
                    :message => params[:message_content]})
  end

end
