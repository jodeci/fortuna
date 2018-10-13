class UpdateReportsToVersion4 < ActiveRecord::Migration[5.1]
  def change
    update_view :reports, version: 4, revert_to_version: 3
  end
end
