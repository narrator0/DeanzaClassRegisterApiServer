class RenameTableSubscription < ActiveRecord::Migration[5.2]
  def change
    rename_table :subscribtions, :subscriptions
  end
end
