require 'spec_helper'

describe TaskList do
  it { should have_many :tasks }
end
