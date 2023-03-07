require 'rspec'
require 'date'

RSpec.configure do |config|
  config.tty = true
  config.color = true
  config.example_status_persistence_file_path = "tmp/rspec_status.txt"
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
  vuln[:curation_level] >= level
end


# Load YML the way we expect: symbolized names,
# even if they specified symbols or not
# NOTE: for Ruby 3.1+, Psych disallows Date classes by default.
#       We chose to allow dates.
def load_yml_the_vhp_way(f)
  YAML.load File.read(f),
    symbolize_names: true,
    permitted_classes: [Date, Symbol]
end