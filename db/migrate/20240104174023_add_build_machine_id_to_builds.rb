class AddBuildMachineIdToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :build_machine_id, :string
  end
end
