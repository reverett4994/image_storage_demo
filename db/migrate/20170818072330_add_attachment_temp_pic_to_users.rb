class AddAttachmentTempPicToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :temp_pic
    end
  end

  def self.down
    remove_attachment :users, :temp_pic
  end
end
