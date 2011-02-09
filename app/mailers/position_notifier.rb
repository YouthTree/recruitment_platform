class PositionNotifier < ActionMailer::Base

  def application_received(app)
    @application = app
    @position    = app.position 
    mail :to => @position.contact_emails.map(&:to_s)
  end

  def application_saved(app)
    @application = app
    @position    = app.position
    mail :to => @application.email_address.to_s
  end

  def application_sent(app)
    @application = app
    @position    = app.position
    mail :to => @application.email_address.to_s
  end

end