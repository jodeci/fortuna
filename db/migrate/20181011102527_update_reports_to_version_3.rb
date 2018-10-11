class UpdateReportsToVersion3 < ActiveRecord::Migration[5.1]
  def change
    update_view :reports, version: 3, revert_to_version: 2
  end
end
