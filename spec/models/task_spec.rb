require 'spec_helper'

describe Task do
  it { should belong_to :project }
  it { should belong_to :task_list }
end
