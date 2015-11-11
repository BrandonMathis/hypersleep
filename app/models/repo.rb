class Repo < ActiveRecord::Base
  belongs_to :user

  def clone
    Dir.mkdir('tmp') unless Dir.exists?('tmp')
    Dir.mkdir("tmp/#{owner}") unless Dir.exists?("tmp/#{owner}")
    `git clone https://#{user.github_token}@github.com/#{full_name} tmp/#{full_name} > /dev/null 2>&1`
  end

  def full_name
    owner + '/' + name
  end
end
