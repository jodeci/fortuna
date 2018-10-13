class UpdateReportsToVersion5 < ActiveRecord::Migration[5.1]
  def change
    update_view :reports, version: 5, revert_to_version: 4
  end
end
