class AddUserToProjects < ActiveRecord::Migration[7.0]
  def change
    Project.destroy_all
    add_reference :projects, :user, null: false, foreign_key: true, type: :uuid
  end
end
