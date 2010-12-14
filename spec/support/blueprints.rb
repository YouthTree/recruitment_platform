require 'machinist/active_record'
require 'forgery'

Team.blueprint do
  name        { Forgery(:name).company_name }
  website_url { "http://#{Forgery(:internet).domain_name}/" }
  description { Forgery(:lorem_ipsum).paragraph }
end