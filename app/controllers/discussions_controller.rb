class DiscussionsController < AjaxController
  include Mumuki::Laboratory::Controllers::Content

  before_action :set_debatable, except: [:subscription]
  before_action :authenticate!, only: [:update, :create]
  before_action :discussion_filter_params, only: :index
  before_action :read_discussion, only: :show

  helper_method :discussion_filter_params

  def index
    @discussions = current_content_discussions.for_user(current_user)
    @filtered_discussions = @discussions.scoped_query_by(discussion_filter_params)
  end

  def show
  end

  def update
    subject.update_status! params[:status], current_user
    redirect_to [@debatable, subject], notice: I18n.t(:discussion_updated)
  end

  def subscription
    current_user&.toggle_subscription!(subject)
    head :ok
  end

  def upvote
    current_user&.toggle_upvote!(subject)
    head :ok
  end

  def create
    discussion = @debatable.discuss! current_user, discussion_params
    redirect_to [@debatable, discussion]
  end

  private

  def current_content_discussions
    @debatable.discussions
  end

  def set_debatable
    @debatable_class = params[:debatable_class]
    @debatable = Discussion.debatable_for(@debatable_class, params)
  end

  def subject
    @discussion ||= Discussion.find_by(id: params[:id])
  end

  def read_discussion
    @discussion.subscription_for(current_user)&.read!
  end

  def discussion_params
    params.require(:discussion).permit(:title, :description)
  end

  def discussion_filter_params
    @filter_params ||= params.permit(Discussion.permitted_query_params)
  end
end
