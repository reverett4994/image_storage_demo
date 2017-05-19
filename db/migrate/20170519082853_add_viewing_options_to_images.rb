class AddViewingOptionsToImages < ActiveRecord::Migration
  def change
    add_column :images, :public, :boolean, :default => true
    add_column :images, :only_friends, :boolean, :default => false
    add_column :images, :private, :boolean, :default => false
  end
end
