module Stasis
  class Chamber
    attr_reader :owner, :name, :token

    def initialize(owner:, name:, token:)
      @owner = owner
      @name = name
      @token = token
    end

    def schedule_for_suspension
      Stasis::Worker.perform_async(owner, name, token)
      mark_suspended
    end

    def suspend_subject
      clone_repo_from_github
      compress_repo
      upload_repo_to_s3
      mark_suspended
      cleanup
    end

    def mark_suspended
      suspended_repo_query.first_or_create(s3_key: s3_key)
    end

    def suspended?
      suspended_repo.present?
    end

    private
    def suspended_repo
      suspended_repo_query.first
    end

    def suspended_repo_query
      SuspendedRepo.where(owner: owner, name: name)
    end

    def compression_format
      '.tar.gz'
    end

    def tar_file
      "#{clone_path}#{compression_format}"
    end

    def full_name
      owner + '/' + name
    end

    def cleanup
      FileUtils.rmdir(clone_path)
      FileUtils.rm_rf(tar_file)
    end

    def compress_repo
      `tar cvzf #{tar_file} -C tmp/#{owner} #{name} > /dev/null 2>&1`
    end

    def upload_repo_to_s3
      File.open(tar_file, 'rb') do |file|
        S3.new(client: S3_CLIENT).put(file, s3_key)
      end
    end

    def s3_key
      full_name + compression_format
    end

    def download_from_s3
      s3_object.get(response_target: tar_file)
    end

    def clone_repo_from_github
      `git clone https://#{@token}@github.com/#{full_name} #{clone_path} > /dev/null 2>&1`
    end

    def clone_path
      Dir.mkdir('tmp') unless Dir.exists?('tmp')
      Dir.mkdir("tmp/#{owner}") unless Dir.exists?("tmp/#{owner}")
      "tmp/#{full_name}"
    end
  end
end
