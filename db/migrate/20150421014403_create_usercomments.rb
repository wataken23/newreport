class CreateUsercomments < ActiveRecord::Migration
  def change
    create_table :usercomments do |t|
      t.integer :user_id
      t.integer :repbody_id
      t.integer :comment_id
      t.date :date
      t.text :body

      t.timestamps
    end
  end
end
