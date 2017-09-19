class User < ActiveRecord::Base
extend FriendlyId
friendly_id :username, use: :slugged
 has_friendship
 has_many :images
 has_many :albums
 has_attached_file :temp_pic
 validates_attachment_content_type :temp_pic, content_type: /\Aimage/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:lockable

end
