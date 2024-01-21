class Job < ApplicationRecord
  belongs_to :build

  def start!
  end
end
