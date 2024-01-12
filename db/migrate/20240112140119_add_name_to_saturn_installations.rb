class AddNameToSaturnInstallations < ActiveRecord::Migration[7.0]
  def change
    add_column :saturn_installations, :name, :string
  end
end
