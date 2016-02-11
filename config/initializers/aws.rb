# load required yaml config
aws_yml = Rails.root.join("config", 'aws.yml').to_s
aws_template = ERB.new File.new(aws_yml).read
aws_config = YAML.load(aws_template.result())[Rails.env]

# set s3 direct upload settings
S3DirectUpload.config do |c|
  c.access_key_id = aws_config["access_key_id"]
  c.secret_access_key = aws_config["secret_access_key"]
  c.bucket = aws_config["s3"]["bucket"]
  c.region = aws_config["s3"]["region"] || "s3"
  c.url = aws_config["s3"]["bucket_url"] || "https://s3.amazonaws.com/#{c.bucket}/"
end

# save the config for use in video controller
VPB::Application.config.aws = aws_config
