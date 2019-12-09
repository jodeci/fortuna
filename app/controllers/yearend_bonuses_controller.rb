# frozen_string_literal: true
class YearendBonusesController < ApplicationController
  def index
    @lunar_years = LunarYear.ordered.page(params[:page])
  end

  def new
    lunar_year = LunarYear.find_by(id: params[:lunar_year_id])
    employee = Employee.find_by(id: params[:employee_id])
    @yearend_bonus = YearendBonus.new
    @presenter = YearendBonusService::NewPresenter.call(employee, lunar_year)
  end

  def create
    @yearend_bonus = YearendBonusService::CreateForm.call(YearendBonus.new, yearend_bonus_params)
    if @yearend_bonus
      redirect_to edit_yearend_bonus_path(@yearend_bonus)
    else
      render :new
    end
  end

  def show
    load_yearend_bonus
  end

  def edit
    load_yearend_bonus
    @presenter = YearendBonusService::EditPresenter.call(@yearend_bonus)
  end

  def update
    load_yearend_bonus
    if YearendBonusService::UpdateForm.call(@yearend_bonus, yearend_bonus_params)
      redirect_to edit_yearend_bonus_path(@yearend_bonus)
    else
      render :edit
    end
  end

  def lunar_year
    @lunar_year = LunarYear.find_by(id: params[:lunar_year_id])
    @reciptents = YearendBonusService::Reciptents.call(@lunar_year)
  end

  private

  def yearend_bonus_params
    params.require(:yearend_bonus).permit(
      :average_wage, :multiplier, :seniority_factor, :salary_based_bonus, :fixed_amount, :cash_benefit,
      :income_tax, :health_insurance, :total, :employee_id, :lunar_year_id
    )
  end

  def load_yearend_bonus
    (@yearend_bonus = YearendBonus.find_by(id: params[:id])) || not_found
  end
end
