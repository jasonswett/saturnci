class Project < ApplicationRecord
  has_many :builds, dependent: :destroy
  belongs_to :user
  belongs_to :saturn_installation

  def to_s
    name
  end
end
