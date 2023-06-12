class BuildEvent < ApplicationRecord
  self.inheritance_column = :_type_not_used
  belongs_to :build

  enum type: {
    spot_instance_requested: 1,
    spot_instance_ready: 0,
    repository_cloned: 2,
    test_suite_started: 3,
    test_suite_finished: 4
  }
end
