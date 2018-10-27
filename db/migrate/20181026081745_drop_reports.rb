class DropReports < ActiveRecord::Migration[5.2]
  def change
    drop_view :reports, revert_to_version: 6
  end
end
