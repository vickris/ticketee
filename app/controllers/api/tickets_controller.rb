class API::TicketsController < ApplicationController
  before_action :find_project, :authenticate_user

  attr_reader :current_user

  def show
    @ticket = @project.tickets.find(params[:id])
    authorize @ticket, :show?
    render json: @ticket
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def authenticate_user
    authenticate_with_http_token do |token|
      @current_user = User.find_by(api_key: token)
    end
  end
end
