class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, index: true
      t.boolean :read
      t.datetime :read_at
      t.text :message
      t.text :data

      t.timestamps
    end
  end
end
