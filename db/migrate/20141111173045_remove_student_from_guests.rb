class RemoveStudentFromGuests < ActiveRecord::Migration
  def change
    remove_column :guests, :student, :bool
  end
end
