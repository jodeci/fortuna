# frozen_string_literal: true
class SalariesController < ApplicationController
  before_action :prepare_employee, except: :index
  before_action :prepare_salary, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @salary = @employee.salaries.build
  end

  def create
    @salary = @employee.salaries.new(salary_params)
    if @salary.save
      redirect_to @employee
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @salary.update_attributes(salary_params)
      redirect_to @employee
    else
      render action: :edit
    end
  end

  def destroy
    @salary.destroy
    redirect_to employee_path(@employee)
  end

  def recent
    @recent_salary = @employee.salaries.ordered.first
  end

  private

  def salary_params
    params.require(:salary).permit(
      :role, :tax_code, :effective_date, :monthly_wage, :hourly_wage, :cycle,
      :equipment_subsidy, :commuting_subsidy, :supervisor_allowance,
      :labor_insurance, :health_insurance, :insured_for_labor, :insured_for_health,
      :monthly_wage_adjustment
    )
  end

  def prepare_employee
    @employee = Employee.find_by(id: params[:employee_id]) or not_found
  end

  def prepare_salary
    @salary = Salary.find_by(id: params[:id]) or not_found
  end
end
