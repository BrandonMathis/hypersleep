class SuspendedRepo < ActiveRecord::Base
  validates_presence_of :s3_key

  def full_name
    owner + '/' + name
  end

  def url
    S3.new(client: S3_CLIENT).url_for(s3_key)
  end
end
