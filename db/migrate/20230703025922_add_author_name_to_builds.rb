class AddAuthorNameToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :author_name, :string
  end
end
