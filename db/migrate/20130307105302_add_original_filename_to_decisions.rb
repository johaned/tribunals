class AddOriginalFilenameToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :original_filename, :string
  end
end
