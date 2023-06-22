class CreateSaturnInstallations < ActiveRecord::Migration[7.0]
  def change
    create_table :saturn_installations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :github_installation_id, null: false

      t.timestamps
    end

    add_index(
      :saturn_installations,
      [:user_id, :github_installation_id],
      unique: true,
      name: 'index_saturn_installations_on_user_and_github_id'
    )
  end
end
