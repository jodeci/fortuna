# frozen_string_literal: true
class SalariesController < ApplicationController
  before_action :prepare_employee, except: :index
  before_action :prepare_salary, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    (@term = Term.find_by(id: params[:term_id])) || not_found
    @salary = @employee.salaries.build
  end

  def edit
  end

  def create
    @salary = @employee.salaries.new(salary_params)
    if SalaryService::Create.call(@salary, salary_params)
      redirect_to @employee
    else
      render :new
    end
  end

  def update
    if SalaryService::Update.call(@salary, salary_params)
      redirect_to @employee
    else
      render :edit
    end
  end

  def destroy
    SalaryService::Destroy.call(@salary, nil)
    redirect_to employee_path(@employee)
  end

  def recent
    @recent_salary = Salary.recent_for(@employee)
  end

  private

  def salary_params
    params.require(:salary).permit(
      :role, :tax_code, :effective_date, :monthly_wage, :hourly_wage, :cycle,
      :equipment_subsidy, :commuting_subsidy, :supervisor_allowance,
      :labor_insurance, :health_insurance, :insured_for_labor, :insured_for_health,
      :monthly_wage_adjustment, :fixed_income_tax, :split, :term_id
    )
  end

  def prepare_employee
    (@employee = Employee.find_by(id: params[:employee_id])) || not_found
  end

  def prepare_salary
    (@salary = Salary.find_by(id: params[:id])) || not_found
  end
end
