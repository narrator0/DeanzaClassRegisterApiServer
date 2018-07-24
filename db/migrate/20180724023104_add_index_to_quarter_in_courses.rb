class AddIndexToQuarterInCourses < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, :quarter
  end
end
