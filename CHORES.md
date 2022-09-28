# VHP Data Shepherd Chores

These are regular tasks that the data shepherd will need to complete on a weekly basis.

## Checklist Template

Copy this template into the issue tracker for each week.

  - [ ] httpd: New vulnerabilities
  - [ ] httpd: `git pull` on the main repo
  - [ ] httpd: `vhp loadcommits`
  - [ ] httpd: `vhp weeklies`
  - [ ] httpd: update releases and any other major project news
  - [ ] ffmpeg: New vulnerabilities
  - [ ] ffmpeg: `git pull` on the main repo
  - [ ] ffmpeg: `vhp loadcommits`
  - [ ] ffmpeg: `vhp weeklies`
  - [ ] ffmpeg: update releases and any other major project news
  - [ ] chromium: New vulnerabilities
  - [ ] chromium: `git pull` on the main repo
  - [ ] chromium: `vhp loadcommits`
  - [ ] chromium: `vhp weeklies`
  - [ ] chromium: update releases and any other major project news
  - [ ] django: New vulnerabilities
  - [ ] django: `git pull` on the main repo
  - [ ] django: `vhp loadcommits`
  - [ ] django: `vhp weeklies`
  - [ ] django: update releases and any other major project news
  - [ ] struts: New vulnerabilities
  - [ ] struts: `git pull` on the main repo
  - [ ] struts: `vhp loadcommits`
  - [ ] struts: `vhp weeklies`
  - [ ] struts: update releases and any other major project news
  - [ ] tomcat: New vulnerabilities
  - [ ] tomcat: `git pull` on the main repo
  - [ ] tomcat: `vhp loadcommits`
  - [ ] tomcat: `vhp weeklies`
  - [ ] tomcat: update releases and any other major project news
  - [ ] systemd: New vulnerabilities
  - [ ] systemd: `git pull` on the main repo
  - [ ] systemd: `vhp loadcommits`
  - [ ] systemd: `vhp weeklies`
  - [ ] systemd: update releases and any other major project news
  - [ ] vhp: `rails data:clear data:all` warnings documented in issues
  - [ ] vhp: `rails data:clear data:all` does not break

## Check for New Vulnerabilities

For each case study, look for new vulnerabilities.
  * (Until we consolidate the `*-vulnerabilities` repos) Visit each vulnerability repo and check its instructions for getting new vulnerabilities
  * Run any scripts that we have to get relevant bugs, fixes, code reviews, etc, or, run `vhp new` to create new YMLs just based on the CVE identifier 

## Review PR backlog

  * Review the vulnerabilities pull requests
  * Every PR should be either merged, or tagged "needs-discussion"

## `vhp loadcommits`

From within each `*-vulnerabilities` repo, run 
