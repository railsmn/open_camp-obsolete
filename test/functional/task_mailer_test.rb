require 'test_helper'

class TaskMailerTest < ActionMailer::TestCase
  test "task_creation" do
    mail = TaskMailer.task_creation
    assert_equal "Task creation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
