# load required yaml config
ga_yml = Rails.root.join("config", 'google-analytics.yml').to_s
if File.exists?(ga_yml)
  ga_template = ERB.new File.new(ga_yml).read
  ga_config = YAML.load(ga_template.result())[Rails.env]
  if ga_config != nil
    GA.tracker = ga_config["tracker"]
  end
end
