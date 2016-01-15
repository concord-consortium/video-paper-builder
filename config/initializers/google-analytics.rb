# load required yaml config
ga_yml = Rails.root.join("config", 'google-analytics.yml').to_s
ga_config = File.exists?(ga_yml) ? YAML.load_file(ga_yml).recursively_symbolize_keys[Rails.env.to_sym] : nil
if ga_config != nil
  GA.tracker = ga_config[:tracker]
end
