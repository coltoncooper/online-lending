class AddRaisedColumnWithDefaultValue < ActiveRecord::Migration[5.0]
  def change
  	add_column :borrowers, :raised, :integer, :default => 0
  end
end
