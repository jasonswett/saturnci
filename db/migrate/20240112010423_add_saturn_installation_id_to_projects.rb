class AddSaturnInstallationIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :saturn_installation, foreign_key: true, type: :uuid
  end
end
