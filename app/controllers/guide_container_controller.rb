class GuideContainerController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content

  before_action :set_guide

  def show
    if current_user?
      @stats = subject.stats_for(current_user)
      @next_exercise = subject.next_exercise(current_user)
    else
      @next_exercise = subject.first_exercise
    end
  end

  private

  def set_guide
    raise Mumuki::Domain::NotFoundError if subject.nil?
    @guide = subject.guide
  end
end
