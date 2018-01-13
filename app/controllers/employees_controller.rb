# frozen_string_literal: true
class EmployeesController < ApplicationController
  before_action :prepare, only: [:show, :edit]

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def prepare
    @employee = Employee.find_by(id: params[:id])
  end
end
