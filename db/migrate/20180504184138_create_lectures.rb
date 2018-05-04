class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.string :title
      t.string :days
      t.string :times
      t.string :instructor
      t.string :location
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
