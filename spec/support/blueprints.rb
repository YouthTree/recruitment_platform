Team.blueprint do
  name        { Forgery(:name).company_name }
  website_url { "http://#{Forgery(:internet).domain_name}/" }
  description { Forgery(:lorem_ipsum).paragraph }
end

Position.blueprint do
  title                 { Forgery(:lorem_ipsum).sentence }
  paid                  { rand(2) < 1 }
  duration              { "#{1 + rand(12)} #{%w(hours days months).choice}" }
  time_commitment       { rand * 12 }
  short_description     { Forgery(:lorem_ipsum).paragraph }
  general_description   { Forgery(:lorem_ipsum).paragraphs(3, :random => true) }
  position_description  { Forgery(:lorem_ipsum).paragraphs(3, :random => true) }
  applicant_description { Forgery(:lorem_ipsum).paragraphs(3, :random => true) }
  paid_description      { Forgery(:lorem_ipsum).paragraphs(3, :random => true) }
  published_at          { (rand(12) + 1).weeks.ago }
  expires_at            { (rand(4) + 1).weeks.from_now }
  team
end

Position.blueprint :unpublished do
  published_at { nil }
end

Position.blueprint :expired do
  published_at { (rand(2) + 3).weeks.ago }
  expires_at   { (rand(2) + 1).weeks.ago }
end

Position.blueprint :draft do
  published_at { nil }
  expires_at   { nil }
end

Question.blueprint do
  question      { Forgery(:lorem_ipsum).sentence }
  short_name    { "Field #{sn}" }
  hint          { rand(2) == 0 ? nil : Forgery(:lorem_ipsum).sentence }
  question_type { Question::VALID_TYPES.choice }
  metadata      { %w(a b c d) if Question::COLLECTION_TYPES.include?(question_type) }
end

User.blueprint do
  email { Forgery(:internet).email_address }
end

PositionApplication.blueprint do
  position
  full_name { Forgery(:name).full_name }
  email     { Forgery(:internet).email_address }
  phone     { Forgery(:address).phone }
end