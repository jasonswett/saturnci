class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs, id: :uuid do |t|
      t.references :build, null: false, foreign_key: true, type: :uuid
      t.string :build_machine_id
      t.text :test_output
      t.text :test_report
      t.text :system_logs

      t.timestamps
    end

    add_index :jobs, :build_machine_id, unique: true
  end
end
