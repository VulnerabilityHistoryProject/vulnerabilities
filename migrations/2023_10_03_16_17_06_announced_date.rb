require 'yaml'
require 'csv'
require 'set'
require 'json'
require 'date'

# MIGRATION STATUS: Done on Oct 3, 2023
raise 'Migration already performed.' # Don't run this migration. Kept for posterity

errors = []
Dir['cves/kernel/CVE*.yml'].each do |yml_file|
  begin
    yml = YAML.load(File.open(yml_file, 'r').read,
                    permitted_classes: [Date, Symbol])

    json = JSON.load_file("../nvdcve/nvdcve/#{yml['CVE']}.json")
    yml['announced_date'] = json['publishedDate'][0..9]
    yml['published_date'] = json['publishedDate'][0..9]

    # Generate the new YML, clean it up, write it out.
    File.open(yml_file, "w+") do |file|
      yml_txt = yml.to_yaml[4..-1] # strip off ---\n
      stripped_yml = ""
      yml_txt.each_line do |line|
        stripped_yml += "#{line.rstrip}\n" # strip trailing whitespace
      end
      file.write(stripped_yml)
      print '.'
    end
  rescue => e
    print '❌'
    errors << e.message
  end
end
if errors.any?
  puts "===ERRORS==="
  puts errors
end
puts '✅Done!'