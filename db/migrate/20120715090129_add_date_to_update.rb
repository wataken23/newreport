class AddDateToUpdate < ActiveRecord::Migration
  def change
    add_column :updates, :date, :string
  end
end
