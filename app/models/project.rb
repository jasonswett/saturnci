class Project < ApplicationRecord
  has_many :builds

  def to_s
    name
  end
end
