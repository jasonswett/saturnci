class ChangeReportFromJsonbToString < ActiveRecord::Migration[7.0]
  def change
    change_column :builds, :report, :string
  end
end
