require_relative 'spec_helper'
require 'yaml'

describe 'CVE yml file' do
  cve_ymls.each do |file|
    it "#{File.basename(file)} should be legal YAML" do
      expect(load_yml_the_vhp_way(file)).to be
    end
  end
end
