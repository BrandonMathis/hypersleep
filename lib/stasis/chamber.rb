module Stasis
  class Chamber
    attr_reader :owner, :name

    def initialize(owner:, name:, token:)
      @owner = owner
      @name = name
    end


    def activate
      clone_repo_from_github
      Repo.where(
        owner: owner,
        name: name
      ).first_or_create(suspended: true)
      upload_to_s3
    end

    private

    def cleanup
      File.rm_rf(clone_path)
    end

    def upload_to_s3
      tar_file = clone_repo_from_github
      `tar cvzf #{name}.tar.gz #{clone_path}`
      # TODO Acutally get this working
      obj = s3.bucket('bucket-name').object('key')
      obj.upload_file('/source/file/path', acl:'public-read')
      obj.public_url
    end

    def clone_repo_from_github
      `git clone https://#{@token}@github.com/#{full_name} #{clone_path} > /dev/null 2>&1`
    end

    def clone_path
      Dir.mkdir('tmp') unless Dir.exists?('tmp')
      Dir.mkdir("tmp/#{owner}") unless Dir.exists?("tmp/#{owner}")
      "tmp/#{full_name}"
    end

    def full_name
      owner + '/' + name
    end
  end
end
