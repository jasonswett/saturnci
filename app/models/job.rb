class Job < ApplicationRecord
  belongs_to :build
  belongs_to :build_machine
end
