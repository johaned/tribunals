class AddSlugsToDecisions < ActiveRecord::Migration
  def up
    add_column :decisions, :slug, :string
    add_index :decisions, :slug, unique: true

    Decision.find_each do |d|
      begin
        d.slug = nil
        d.save!
      rescue
        puts "Could not save decision with id = #{d.id}, ignoring."
      end
    end
  end

  def down
    remove_column :decisions, :slug
  end
end
