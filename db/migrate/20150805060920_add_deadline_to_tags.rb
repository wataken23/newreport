class AddDeadlineToTags < ActiveRecord::Migration
  def change
    add_column :tags, :deadline, :string, :default => '2999-12-31 23:59:59'   
  end
end
