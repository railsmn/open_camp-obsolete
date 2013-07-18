require 'spec_helper'

describe Project do 
	it { should have_many :notes }
	it { should have_many :tasks }
end
