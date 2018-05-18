class AddQuarterDataToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :quarter, :string
  end
end
