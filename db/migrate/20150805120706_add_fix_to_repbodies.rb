class AddFixToRepbodies < ActiveRecord::Migration
  def change
    add_column :repbodies, :fix, :boolean, default: true, null: false
  end
end
