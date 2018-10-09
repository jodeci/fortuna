class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_view :reports
  end
end
