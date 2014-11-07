class AddInfoToGuests < ActiveRecord::Migration
  def change
    remove_column :guests, :student, :string
    add_column :guests, :student, :bool
    add_column :guests, :zip, :integer
    add_column :guests, :first_name, :string
    add_column :guests, :last_name, :string
  end
end
