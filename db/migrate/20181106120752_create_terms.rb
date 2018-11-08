class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms do |t|
      t.date :start_date, default: nil, index: true
      t.date :end_date, default: nil, index: true

      t.integer :employee_id, index: true
      t.timestamps
    end
  end
end
