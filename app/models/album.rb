class Album < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :images
  validates :name, uniqueness: true

  before_save :downcase_name

  def downcase_name
    self.name.downcase!
  end
end
