require_relative 'spec_helper'
require 'yaml'

describe 'CVE yml file' do
  cve_ymls.each do |file|
    it "#{File.basename(file)} should be legal YAML" do
      expect(YAML.load(File.open(file))).to be
    end
  end
end
