# load required yaml config
aws_yml = Rails.root.join("config", 'aws.yml').to_s
aws_config = YAML.load_file(aws_yml)[Rails.env]

# set s3 direct upload settings
S3DirectUpload.config do |c|
  c.access_key_id = aws_config["access_key_id"]
  c.secret_access_key = aws_config["secret_access_key"]
  c.bucket = aws_config["s3"]["bucket"]
  c.region = aws_config["s3"]["region"] || "s3"
  c.url = "https://#{c.region}.amazonaws.com/#{c.bucket}/"
end

#AWS.config(
#  :access_key_id => aws_config["access_key_id"],
#  :secret_access_key => aws_config["secret_access_key"]
#)

# save the config for use in video controller
VPB::Application.config.aws = aws_config
