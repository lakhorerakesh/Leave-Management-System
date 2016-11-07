class CreateTimings < ActiveRecord::Migration
  def change
    create_table :timings do |t|
      t.time :start_time
      t.time :end_time
      t.integer :leave_id
      t.string :leave_date
      t.timestamps
    end
  end
end
