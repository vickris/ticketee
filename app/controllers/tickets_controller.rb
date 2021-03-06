class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :watch]

  def new
    @ticket = @project.tickets.build
    authorize @ticket, :create?
    @ticket.attachments.build
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.user = current_user

    authorize @ticket, :create?
    if @ticket.save
      flash[:success] = "Ticket was created successfully"
      redirect_to [@project, @ticket]
    else
      flash.now[:danger] = "Ticket has not been created"
      render :new
    end

  end

  def show
    authorize @ticket, :show?
    @comment = @ticket.comments.build(state_id: @ticket.state_id)
    respond_to do |format|
      format.html
      format.json { render json: @ticket }
    end
  end

  def watch
    authorize @ticket, :show?

    if @ticket.watchers.exists?(current_user)
      @ticket.watchers.destroy(current_user)
      flash[:notice] = "You are no longer watching this ticket."
    else
      @ticket.watchers << current_user
      flash[:notice] = "You are now watching this ticket."
    end

    redirect_to project_ticket_path(@ticket.project, @ticket)

  end

  def edit
    authorize @ticket, :update?
  end

  def update
    authorize @ticket, :update?

    if @ticket.update(ticket_params)
      flash[:success] = "Ticket was updated successfully"
      redirect_to [@project, @ticket]
    else
      flash.now[:danger] = "Error updating ticket"
      render :edit
    end
  end


  def destroy
    authorize @ticket, :destroy?

    @ticket.destroy
    flash[:success] = "Ticket was deleted successfully"
    redirect_to @project
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:name, :description, :tag_names,
      attachments_attributes: [:file, :file_cache])
  end
end
