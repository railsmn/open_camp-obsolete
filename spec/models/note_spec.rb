require 'spec_helper'

describe Note do 
  it { should belong_to :project }
end
