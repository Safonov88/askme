class AddIndexToUser < ActiveRecord::Migration[5.1]
  def change
    add_index :users, [:username, :email], unique: true
  end
end
