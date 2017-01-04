class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def new
    @ticket = @project.tickets.build
  end

  def create
    @ticket = @project.tickets.build(ticket_params)

    if @ticket.save
      flash[:success] = "Ticket was created successfully"
      redirect_to [@project, @ticket]
    else
      flash.now[:danger] = "Ticket has not been created"
      render :new
    end

  end

  def show
  end

  def edit
  end

  def update
    if @ticket.update(ticket_params)
      flash[:success] = "Ticket was updated successfully"
      redirect_to [@project, @ticket]
    else
      flash.now[:danger] = "Error updating ticket"
      render :edit
    end
  end


  def destroy
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
    params.require(:ticket).permit(:name, :description)
  end
end