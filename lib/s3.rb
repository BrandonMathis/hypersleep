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
end
