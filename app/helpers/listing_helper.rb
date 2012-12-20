# Helper methods defined here can be accessed in any controller or view in the application

Pdfupper.helpers do
  # def simple_helper_method
  #  ...
  # end
  def send_email(a_to_address, a_from_address , a_subject, a_type)
  begin
    case settings.environment
    when :development                          # assumed to be on your local machine
    	body = render 'listing/email', :layout => false
      Pony.mail :to => a_to_address, :via =>:sendmail,
        :from => a_from_address, :subject => a_subject,
        :headers => { 'Content-Type' => a_type }, :body => body
    when :production                         # assumed to be Heroku
      Pony.mail :to => a_to_address, :from => a_from_address, :subject => a_subject,
        :headers => { 'Content-Type' => a_type }, :body => body, :via => :smtp,
        :via_options => {
          :address => 'mail.propertyline.com',
          :port => 25,
          :authentication => :plain }
          #:user_name => ENV['SENDGRID_USERNAME'],
          #:password => ENV['SENDGRID_PASSWORD'],
          #:domain => ENV['SENDGRID_DOMAIN'] }
    when :test
      # don't send any email but log a message instead.
      logger.debug "TESTING: Email would now be sent to #{to} from #{from} with subject #{subject}."
    end
  rescue StandardError => error
    logger.error "Error sending email: #{error.message}"
  end
end
end
