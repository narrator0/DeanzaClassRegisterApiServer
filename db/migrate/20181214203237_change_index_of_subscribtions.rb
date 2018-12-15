class ChangeIndexOfSubscribtions < ActiveRecord::Migration[5.2]
  def change
    remove_index :subscriptions, column: [:user_id, :course_id]
    add_index :subscriptions, [:user_id, :course_id]
  end
end
