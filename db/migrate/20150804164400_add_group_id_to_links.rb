class AddGroupIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :group_id, :integer
    add_index :links, :group_id
  end
end
