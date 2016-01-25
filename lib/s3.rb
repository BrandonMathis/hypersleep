class S3
  attr_reader :client

  def initialize(client:)
    @client = client
  end

  def bucket
    'sb-github-repos'
  end

  def put(object, s3_key)
    client.put_object(
      acl: 'private',
      bucket: bucket,
      key: s3_key,
      body: object
    )
  end

  def url_for(s3_key)
    signer = Aws::S3::Presigner.new(client: S3_CLIENT)
    signer.presigned_url(:get_object, bucket: bucket, key: s3_key, expires_in: 5.minutes)
  end
end
