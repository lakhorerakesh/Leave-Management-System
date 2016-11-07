class AddMyBooleanToTimings < ActiveRecord::Migration
  def change
    add_column :timings, :my_boolean, :integer

  end
end
