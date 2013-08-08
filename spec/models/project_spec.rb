require 'spec_helper'

describe Project do
  it { should have_many :tasks } 
  it { should have_many :notes } 
end
