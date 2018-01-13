# frozen_string_literal: true
class EmployeesController < ApplicationController
  before_action :prepare, only: [:show, :edit, :update]

  def index
  end

  def new
    @employee = Employee.new
    @employee.salaries.build
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.salaries.build
    if @employee.save
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
    if @employee.update_attributes(employee_params)
      redirect_to @employee
    else
      render action: :edit
    end
  end

  def destroy
  end

  private

  def employee_params
    params.require(:employee).permit(
      :name, :role, :id_number, :birthday,
      :company_email, :personal_email,
      :start_date, :end_date, :bank_account,
      salaries_attributes: salaries_attributes
    )
  end

  def salaries_attributes
    [
      :tax_code, :start_date, :monthly_wage, :hourly_wage,
      :equipment_subsidy, :commuting_subsidy, :supervisor_allowance,
      :labor_insurance, :health_insurance,
    ]
  end

  def prepare
    @employee = Employee.find_by(id: params[:id]) or not_found
  end
end
