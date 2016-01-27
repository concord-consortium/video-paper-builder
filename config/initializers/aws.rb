# load required yaml config
aws_yml = Rails.root.join("config", 'aws.yml').to_s
unless File.exists?(aws_yml)
  raise RuntimeError, "Unable to find required \"config/aws.yml\" configuration file."
end
aws_config = YAML.load_file(aws_yml)[Rails.env]

# validate yaml config
unless aws_config.has_key? "s3"
  raise RuntimeError, "Unable to find required s3 configuration in \"config/aws.yml\" configuration file."
end
["access_key_id", "secret_access_key"].each do |key|
  unless aws_config["credentials"].has_key?(key) && !aws_config["credentials"][key].empty?
    raise RuntimeError, "Unable to find required aws credentials configuration #{key} value in \"config/aws.yml\" configuration file."
  end
end
["bucket"].each do |key|
  unless aws_config["s3"].has_key?(key) && !aws_config["s3"][key].empty?
    raise RuntimeError, "Unable to find required s3 configuration #{key} value in \"config/aws.yml\" configuration file."
  end
end

# set s3 direct upload settings
S3DirectUpload.config do |c|
  c.access_key_id = aws_config["credentials"]["access_key_id"]
  c.secret_access_key = aws_config["credentials"]["secret_access_key"]
  c.bucket = aws_config["s3"]["bucket"]
  c.region = aws_config["credentials"]["region"] || "s3"
  c.url = "https://#{c.region}.amazonaws.com/#{c.bucket}/"
end

AWS.config(
  :access_key_id => aws_config["credentials"]["access_key_id"],
  :secret_access_key => aws_config["credentials"]["secret_access_key"]
)

# save the config for use in video controller
VPB::Application.config.aws = aws_config
