require 'yaml'

# MIGRATION STATUS: Not done yet.
# raise 'Migration already performed.' # Don't run this migration. Kept for posterity

def order_of_keys
  # This is just an example - edit to your liking.
  # To get the latest from your skeleton, run this in your console:
  # puts YAML.load(File.open('skeletons/cve.yml',).read).keys.join("\n")
  %w(
    CVE
    yaml_instructions
    curated_instructions
    curation_level
    reported_instructions
    reported_date
    announced_instructions
    announced_date
    published_instructions
    published_date
    description_instructions
    description
    bounty_instructions
    bounty
    reviews
    bugs
    repo
    fixes_vcc_instructions
    fixes
    vccs
    upvotes_instructions
    upvotes
    unit_tested
    discovered
    discoverable
    specification
    subsystem
    interesting_commits
    i18n
    sandbox
    ipc
    lessons
    mistakes
    CWE_instructions
    CWE
    CWE_note
    nickname_instructions
    nickname
    CVSS
  )
end

ymls = Dir['cves/django/*.yml']
ymls.each do |yml_file|
  h = YAML.load(File.open(yml_file, 'r').read)

  # Do stuff to your hash here.
  if h['curated']
    h['curated_instructions'] = <<~EOS
    If you are manually editing this file, then you are "curating" it.

    Set the version number that you were given in your instructions.

    This will enable additional editorial checks on this file to make sure you
    fill everything out properly. If you are a student, we cannot accept your work
    as finished unless curated is properly updated.
    EOS
    h['curation_level'] = 1
  end

  if h["curation_level"].nil?
    h["curation_level"] = 0
  end

  # Reconstruct the hash in the order we specify
  out_h = {}
  order_of_keys.each do |key|
    out_h[key] = h[key]
  end

  # Generate the new YML, clean it up, write it out.
  File.open(yml_file, "w+") do |file|
    yml_txt = out_h.to_yaml[4..-1] # strip off ---\n
    stripped_yml = ""
    yml_txt.each_line do |line|
      stripped_yml += "#{line.rstrip}\n" # strip trailing whitespace
    end
    file.write(stripped_yml)
    print '.'
  end
end
puts 'Done!'
