require "spec_helper"

describe PositionNotifier do

  describe "the application received notice" do

    let(:position)             { Position.make! }
    let(:position_application) { PositionApplication.make!(:position => position) }
    let(:mail)                 { PositionNotifier.application_received(position_application) }
    subject                    { mail }

    its(:to)      { should == position.contact_emails.map(&:to_s) }
    its(:from)    { should == [Settings.mailer.from] }
    its(:subject) { should == 'New Position Application Received' }

    context 'the message body' do

      subject { mail.body.encoded }

      it 'should have a link to the position' do
        should have_link_to position.title, admin_position_url(position)
      end

      it 'should have a link to the team' do
        should have_link_to position.team.name, admin_team_url(position.team)
      end

      it 'should have a link to the application' do
        should have_link_to /.*/, admin_position_position_application_url(position, position_application)
      end

    end

  end

end
