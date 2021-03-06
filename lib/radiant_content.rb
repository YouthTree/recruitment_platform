require 'open-uri'
require 'timeout'
require 'singleton'

class RadiantContent
  include Singleton
  
  TIMEOUT = 15

  def self.[](name)
    instance[name]
  end
  
  def content
    cached = cache.read('radiant-content')
    return JSON.parse(cached) if cached.present?
    fetched = fetch_json
    if fetched.present?
      cache.write('radiant-content', fetched, :expires_in => 30.minutes)
    end
    fetched.present? ? JSON.parse(fetched) : {}
  end
  
  def [](name)
    content[name.to_s].to_s.html_safe
  end
  
  def fetch_json
    if Settings.radiant.host?
      url = "http://#{Settings.radiant.host}/snippets.json"
      Timeout.timeout(TIMEOUT) do
        open(url).read
      end
    end
  rescue Timeout::Error, SystemCallError, OpenURI::HTTPError
    nil
  end
  
  protected
  
  def cache
    Rails.cache
  end
  
end