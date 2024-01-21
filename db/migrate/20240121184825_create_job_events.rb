class CreateJobEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :job_events, id: :uuid do |t|
      t.references :job, null: false, foreign_key: true, type: :uuid
      t.integer :type, null: false

      t.timestamps
    end

    add_index :job_events, %i[job_id type], unique: true
  end
end
