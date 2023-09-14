# frozen_string_literal: true
class TermsController < ApplicationController
  before_action :prepare_employee, except: :index
  before_action :prepare_term, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @term = @employee.terms.build
  end

  def edit
  end

  def create
    @term = @employee.terms.new(term_params)
    if @term.save
      redirect_to @employee
    else
      render :new
    end
  end

  def update
    if @term.update(term_params)
      redirect_to @employee
    else
      render :edit
    end
  end

  def destroy
    @term.destroy
    redirect_to employee_path(@employee)
  end

  private

  def term_params
    params.require(:term).permit(:start_date, :end_date)
  end

  def prepare_employee
    (@employee = Employee.find_by(id: params[:employee_id])) || not_found
  end

  def prepare_term
    (@term = Term.find_by(id: params[:id])) || not_found
  end
end
