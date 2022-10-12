require 'rspec'
RSpec.configure do |config|
  config.tty = true
  config.color = true
end

def cve_dir
  File.expand_path "#{File.dirname(__FILE__)}/../cves"
end

def cve_yml(project, cve)
  File.expand_path "#{File.dirname(__FILE__)}/../cves/#{project}/#{cve}.yml"
end

def cve_ymls
  Dir["#{cve_dir}/**/*.yml"].map
end

def cve_hash(file)
  YAML.load(File.open(file))
end

def valid_git_hash_or_empty(str)
  str.nil? ||
    str.to_s.nil? ||
    str =~ /[0-9a-z]{40}/
end

def at_curation_level?(vuln, level)
  vuln['curation_level'] >= level
end
