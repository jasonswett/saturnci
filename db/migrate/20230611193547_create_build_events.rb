class CreateBuildEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :build_events, id: :uuid do |t|
      t.references :build, null: false, foreign_key: true, type: :uuid
      t.integer :type, null: false

      t.timestamps
    end

    add_index :build_events, [:build_id, :type], unique: true
  end
end
