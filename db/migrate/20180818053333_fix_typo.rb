class FixTypo < ActiveRecord::Migration[5.2]
  def change
    rename_column :courses, :seats_availible, :seats_available
    rename_column :courses, :waitlist_slots_availible, :waitlist_slots_available
  end
end
