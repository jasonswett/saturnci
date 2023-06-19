class Project < ApplicationRecord
  has_many :builds, dependent: :destroy

  def to_s
    name
  end
end
