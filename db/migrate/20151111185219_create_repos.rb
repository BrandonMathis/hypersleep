class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :owner
      t.boolean :suspended
      t.string :path

      t.timestamps null: false
    end
  end
end
