require 'dataset/extensions/rspec'

module DatasetCleanerHelper
  
  def cleanup_after_models!(*model_klasses)
    klasses = model_klasses.flatten.uniq
    before(:all) { klasses.each(&:delete_all) }
    after(:all)  { klasses.each(&:delete_all) }
  end
  
end