# frozen_string_literal: true
class LunarYearsController < ApplicationController
  def new
    @lunar_year = LunarYear.new
  end

  def create
    @lunar_year = LunarYear.new(lunar_year_params)
    if @lunar_year.save
      redirect_to yearend_bonuses_path
    else
      render :new
    end
  end

  def edit
    load_lunar_year
  end

  def update
    load_lunar_year
    if @lunar_year.update(lunar_year_params)
      redirect_to yearend_bonuses_path
    else
      render :edit
    end
  end

  private

  def lunar_year_params
    params.require(:lunar_year).permit(
      :year, :last_working_day
    )
  end

  def load_lunar_year
    (@lunar_year = LunarYear.find_by(id: params[:id])) || not_found
  end
end
