class BuildEvent < ApplicationRecord
  self.inheritance_column = :_type_not_used
  belongs_to :build

  enum type: {
    build_machine_requested: 1,
    build_machine_ready: 0,
    repository_cloned: 2,
    test_suite_started: 3,
    test_suite_finished: 4,
    pre_script_started: 5,
    pre_script_finished: 6,
    image_build_started: 7,
    image_build_finished: 8
  }
end
