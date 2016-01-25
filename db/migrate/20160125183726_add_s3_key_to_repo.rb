class AddS3KeyToRepo < ActiveRecord::Migration
  def change
    add_column :suspended_repos, :s3_key, :string
  end
end
