class UpdateReportsToVersion7 < ActiveRecord::Migration[5.2]
  def change
    create_view :reports, version: 7
  end
end
