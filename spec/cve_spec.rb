require_relative 'spec_helper'
require 'yaml'

describe 'CVE yml file' do

  cve_ymls.each do |file|

    context "#{File.basename(file)}" do
      let(:vuln) { load_yml_the_vhp_way(file) }

      it 'has valid git hashes and commit/note structure in fixes, vccs, and interesting_commits' do
        git_regex = /[0-9a-f]{40,}/
        vuln[:fixes].each do |fix|
          expect(fix[:commit]).to(match(git_regex).or(be_nil).or(be_empty))
        end
        vuln[:vccs].each do |fix|
          expect(fix[:commit]).to(match(git_regex).or(be_nil).or(be_empty))
        end
        vuln[:interesting_commits][:commits].each do |fix|
          expect(fix[:commit]).to(match(git_regex).or(be_nil).or(be_empty))
        end
      end

      context 'when curated at level 1, it' do

        it 'should have a description and mistakes made written' do
          if at_curation_level?(vuln, 1)
            expect(vuln[:description].to_s).not_to be_empty
            expect(vuln[:mistakes][:answer].to_s).not_to be_empty
          end
        end

      end

      context 'when curated at level 2, it' do

        it 'should have the CWE filled out' do
          if at_curation_level?(vuln, 1)
            expect(vuln[:CWE].to_s).not_to be_empty
          end
        end

        it 'should have answers for unit_tested, sandbox, i18n, and ipc' do
          if at_curation_level?(vuln, 2)
            expect(vuln[:unit_tested][:code]).to be(true).or(be(false))
            expect(vuln[:unit_tested][:fix]).to be(true).or(be(false))
            expect(vuln[:sandbox][:note].to_s).not_to be_empty
            expect(vuln[:sandbox][:answer]).to be(true).or(be(false))
            expect(vuln[:i18n][:note].to_s).not_to be_empty
            expect(vuln[:i18n][:answer]).to be(true).or(be(false))
            expect(vuln[:ipc][:note].to_s).not_to be_empty
            expect(vuln[:ipc][:answer]).to be(true).or(be(false))
          end
        end

        it 'should have answers for disagreement, vouch, stacktrace' do
          if at_curation_level?(vuln, 2)
            expect(vuln[:discussion][:discussed_as_security]).to be(true).or(be(false))
            expect(vuln[:discussion][:any_discussion]).to be(true).or(be(false))
            expect(vuln[:discussion][:note].to_s).not_to be_empty
            expect(vuln[:vouch][:note].to_s).not_to be_empty
            expect(vuln[:vouch][:answer]).to be(true).or(be(false))
            expect(vuln[:stacktrace][:any_stacktraces]).to be(true).or(be(false))
            expect(vuln[:stacktrace][:stacktrace_with_fix]).to be(true).or(be(false))
            expect(vuln[:stacktrace][:note].to_s).not_to be_empty
          end
        end

        it 'should have answers for forgotten_check, discovered, autodiscoverable, & specification' do
          if at_curation_level?(vuln, 2)
            expect(vuln[:forgotten_check][:note].to_s).not_to be_empty
            expect(vuln[:forgotten_check][:answer]).to be(true).or(be(false))
            expect(vuln[:discovered][:answer].to_s).not_to be_empty
            expect(vuln[:discovered][:automated]).to be(true).or(be(false))
            expect(vuln[:discovered][:contest]).to be(true).or(be(false))
            expect(vuln[:discovered][:developer]).to be(true).or(be(false))
            expect(vuln[:autodiscoverable][:note].to_s).not_to be_empty
            expect(vuln[:autodiscoverable][:answer]).to be(true).or(be(false))
            expect(vuln[:specification][:note].to_s).not_to be_empty
            expect(vuln[:specification][:answer]).to be(true).or(be(false))
          end
        end

        it 'has properly formatted subsystem names' do
          if at_curation_level?(vuln, 2)
            expect(vuln[:subsystem][:name].to_s).not_to be_empty
            subsystem_str = Array[vuln[:subsystem][:name]].join
            expect(subsystem_str).to match(/^[a-z\s0-9\_\-\@\/]+$/)
          end
        end
      end

      it 'has an empty nickname or under 30 chars' do
        expect(vuln[:nickname].to_s.length).to be <= 30
      end

      it 'has lessons properly formatted' do
        expect(vuln[:lessons][:defense_in_depth][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:least_privilege][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:frameworks_are_optional][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:native_wrappers][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:distrust_input][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:security_by_obscurity][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:serial_killer][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:environment_variables][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:secure_by_default][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:yagni][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
        expect(vuln[:lessons][:complex_inputs][:applies]).to be(true).
                                                               or(be(false)).
                                                               or(be_nil)
      end

    end

  end

end
