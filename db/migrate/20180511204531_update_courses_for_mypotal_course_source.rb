class UpdateCoursesForMypotalCourseSource < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :status, :integer
    add_column :courses, :campus, :string
    add_column :courses, :units, :float
    add_column :courses, :seats_availible, :integer
    add_column :courses, :waitlist_slots_availible, :integer
    add_column :courses, :waitlist_slots_capacity, :integer
  end
end
