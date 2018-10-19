class AddDetailInfoToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :description, :text
    add_column :courses, :class_material, :string
    add_column :courses, :prerequisites_note, :text
    add_column :courses, :prerequisites_advisory, :text
  end
end
