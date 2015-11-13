s3 = Aws::S3::Resource.new(
  credentials: Aws::Credentials.new('akid', 'secret'),
  region: 'us-west-1'
)
 
obj = s3.bucket('bucket-name').object('key')
obj.upload_file('/source/file/path', acl:'public-read')
obj.public_url
