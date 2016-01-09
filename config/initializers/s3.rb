credentials = Aws::Credentials.new(
  Rails.application.secrets.s3['access_key_id'],
  Rails.application.secrets.s3['secret_access_key']
)

if Rails.env.test?
  S3_CLIENT = Aws::S3::Client.new(
    region: 'us-east-1',
    credentials: credentials,
    stub_responses: true
  )
else
  S3_CLIENT = Aws::S3::Client.new(
    region: 'us-east-1',
    credentials: credentials
  )
end
