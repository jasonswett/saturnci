class CreateBuildLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :build_logs, id: :uuid do |t|
      t.references :build, null: false, foreign_key: true, type: :uuid
      t.text :content, null: false

      t.timestamps
    end
  end
end
