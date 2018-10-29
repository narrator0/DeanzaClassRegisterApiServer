class AddCachedLectureToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :cached_lecture, :text
  end
end
