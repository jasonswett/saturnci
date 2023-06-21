class Project < ApplicationRecord
  has_many :builds, dependent: :destroy
  belongs_to :user

  def to_s
    name
  end
end
