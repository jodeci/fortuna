class CreateSalaryTrackers < ActiveRecord::Migration[5.2]
  def change
    create_view :salary_trackers
  end
end
