require 'spec_helper'

describe Tagging do
  
  context 'associations' do
    it { should belong_to :tag }
    it { should belong_to :taggable, :polymorphic => true }
  end
  
end
