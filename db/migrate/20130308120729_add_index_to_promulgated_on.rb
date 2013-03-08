class AddIndexToPromulgatedOn < ActiveRecord::Migration
  def change
    add_index(:decisions, :promulgated_on, :order => {:promulgated_on => :desc})
  end
end
