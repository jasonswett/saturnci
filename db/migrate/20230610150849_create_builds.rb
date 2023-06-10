class CreateBuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :builds, id: :uuid do |t|
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
