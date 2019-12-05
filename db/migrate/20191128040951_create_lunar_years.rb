class CreateLunarYears < ActiveRecord::Migration[5.2]
  def change
    create_table :lunar_years do |t|
      t.integer :year
      t.date :last_working_day

      t.timestamps
    end

    add_index :lunar_years, [:year], unique: true
  end
end
