class AddTypeToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :type, :string
  end
end
