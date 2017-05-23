class User < ActiveRecord::Base
 has_friendship
 has_many :images
 has_many :albums
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:lockable

end
