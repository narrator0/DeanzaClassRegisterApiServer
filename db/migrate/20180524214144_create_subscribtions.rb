class CreateSubscribtions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribtions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      t.timestamps
    end

    add_index :subscribtions, [:user_id, :course_id], unique: true
  end
end
