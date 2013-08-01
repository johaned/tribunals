class AddNcn < ActiveRecord::Migration
  def change
    add_column :decisions, :ncn, :string
  end
end
