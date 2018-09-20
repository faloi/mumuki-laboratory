module Mumuki::Laboratory::Status::Submission::Passed
  extend Mumuki::Laboratory::Status::Submission

  def self.passed?
    true
  end

  def self.iconize
    {class: :success, type: 'check-circle'}
  end
end