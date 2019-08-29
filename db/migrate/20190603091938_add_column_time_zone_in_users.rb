class AddColumnTimeZoneInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :time_zone, :string, default: 'London'
  end
end
