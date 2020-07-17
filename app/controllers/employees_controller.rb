# frozen_string_literal: true
class EmployeesController < ApplicationController
  before_action :prepare, only: [:show, :edit, :update, :destroy]
  before_action :store_location, only: [:show]

  def index
    list = SalaryTracker.on_payroll.by_role(role: %w[boss regular contractor])
    @result = Kaminari.paginate_array(list).page(params[:page])
  end

  def parttimers
    list = SalaryTracker.on_payroll.by_role(role: %w[vendor advisor parttime])
    @result = Kaminari.paginate_array(list).page(params[:page])
    render :index
  end

  def inactive
    @result = SalaryTracker.inactive.page(params[:page])
    render :index
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee
    else
      render :new
    end
  end

  def show
    @payrolls = @employee.payrolls.personal_history
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee
    else
      render :edit
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path
  end

  private

  def employee_params
    params.require(:employee).permit(
      :name, :role, :id_number, :birthday, :b2b,
      :company_email, :personal_email, :residence_address,
      :bank_account, :bank_transfer_type,
      salaries_attributes: salaries_attributes,
      terms_attributes: [:start_date, :end_date, :_destory, :id]
    )
  end

  def salaries_attributes
    [
      :tax_code, :effective_date, :monthly_wage, :hourly_wage,
      :equipment_subsidy, :commuting_subsidy, :supervisor_allowance,
      :labor_insurance, :health_insurance, :_destroy, :id,
    ]
  end

  def prepare
    (@employee = Employee.find_by(id: params[:id])) || not_found
  end
end
