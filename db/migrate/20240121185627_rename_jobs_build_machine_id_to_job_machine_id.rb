class RenameJobsBuildMachineIdToJobMachineId < ActiveRecord::Migration[7.1]
  def change
    rename_column :jobs, :build_machine_id, :job_machine_id
  end
end
