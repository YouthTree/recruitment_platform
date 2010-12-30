require "spec_helper"

describe PositionNotifier do
  describe "the application received notice" do
    let(:position)             { Position.make! }
    let(:position_application) { PositionApplication.make!(:position => position) }
    let(:mail)                 { PositionNotifier.application_received(position_application) }
    subject                    { mail }

    its(:to)   { should == position.contact_emails.map(&:to_s) }
    its(:from) { should == [Settings.mailer.from] }

    pending "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
