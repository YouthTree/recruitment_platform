module MiscSpecExt

  def self.included(parent)
    ActionDispatch::Routing::RouteSet.class_eval do
      
      def default_url_options
        ActionMailer::Base.default_url_options
      end
      
    end
  end
  
end