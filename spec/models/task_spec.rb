require 'spec_helper'

describe Task do 

  it 'true equals true' do
    true.should == true
  end

  it 'true not equal false' do 
    true.should_not == false
  end

  it '2nd simple test' do 
    (2 + 2).should == 4
  end

end