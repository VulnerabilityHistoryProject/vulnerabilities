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
- [ ] vhp: if any of the above operations fails, create a bug for it on the corresponding `*-vulnerabiltiies` repository.
- [ ] vhp: `rails data:clear data:all` warnings documented in issues
- [ ] vhp: `rails data:clear data:all` does not break
- [ ] vhp: `vhp` shepherd tools - any bugs or feature ideas?

## Check for New Vulnerabilities

For each case study, look for new vulnerabilities.
  * (Until we consolidate the `*-vulnerabilities` repos) Visit each vulnerability repo and check its instructions for getting new vulnerabilities
  * Run any scripts that we have to get relevant bugs, fixes, code reviews, etc, or, run `vhp new` to create new YMLs just based on the CVE identifier 
  * If there were no new vulnerabilities recently, no need to do the other things


## Review PR backlog

  * Review the vulnerabilities pull requests
  * Every PR should be either merged, or tagged "needs-discussion"

## `vhp loadcommits`

You'll do this locally, but you'll need the source repo cloned. Most of the projects that's not a problem, but chromium is quite big. 

Alternatively, you can use our `artifacts` server or RIT's Research Computing Cluster. Andy can show you how those work. Tends to run much much faster on our servers. 

* `cd` to the root of each `*-vulnerabilities` repo
* Make sure you have the latest source repo. A clean `git clone` can sometimes be easier than `git pull` if the repo is huge
* Run `vhp loadcommits` to update gitlog.json
* Inspect the output that everything is as you think it is
* Check the size of gitlog.json before and after - did it jump way up in size? There might be a mega-commit in there - file a bug and we'll fix that.
* Commit to the `dev` branch of the vulnerabilties repo
* Push to GitHub
* Make sure the CI builds properly for the specs and `data:all`


## `vhp weeklies`

Alternatively, you can use our `artifacts` server or RIT's Research Computing Cluster. Andy can show you how those work. Tends to run much much faster on our servers. 

* `cd` to the root of each `*-vulnerabilities` repo
* Make sure you have the latest source repo. A clean `git clone` can sometimes be easier than `git pull` if the repo is huge
* Run `vhp weeklies `. This one can take a while - a few minutes to sometimes overnight.
* Inspect the output that everything is as you think it is
* Check the size of gitlog.json before and after - did it jump way up in size? There might be a mega-commit in there - file a bug and we'll fix that.
* Commit to the `dev` branch of the vulnerabilties repo
* Push to GitHub
* Make sure the CI builds properly for the specs and `data:all`

## VCC identifying

Documentation TBD, but you'll be running archeogit on the new CVEs and it'll update all the ymls with their potential VCCs.

# Useful Tips and Tools

* SSH: for working on the servers, you'll need an SSH client. We recommend MobaXTerm or PuTTY for Windows, or just the terminal for Mac. MobaXTerm has a ton of nice features.
* `artifacts` is a server we have devoted to long computatational tasks.
    * It has a lot of RAM, and the directory `/dev/shm` is a RAMDisk. Note: if artifacts reboots, `/dev/shm` is wiped. So don't put things that need to be permanent there. BUT, IO-heavy operations like with Git and our other scripts will usually go much faster there.
    * Feel free to use `tmux` to detach your session so you can log out and have your session still running
* Get the Windows "Terminal" app from the store - learn more https://github.com/microsoft/terminal
* Research computing (TBD - very useful too)

# Getting Started as a Data Shepherd

* Install Ruby (the latest)
    * Mac: we recommend `rbenv` via `brew`
    * Windows: use [https://rubyinstaller.org/](https://rubyinstaller.org/)
* Clone various repos:
    * `*-vulnerabilities` repos - where your main work will be.
    * `shepherd-tools` repo - these are where we have the `vhp` commandline tool that will help you. 
    * `vulnerability-history` - this is for our main website. Technically not required, but useful sometimes.
    * Clone the source repos of the case studies. Currently we have that set up as `rake pull:repo` so that it clones into `*-vulnerabilities/tmp/src`. 
        * Consult the READMEs of each vulnerabilities repo
        * If you cloned the repos elsewhere - that's fine. When you run your `vhp` commands, specify `--repo`
        * Note that Chromium's repo is several gigs in size and can fail on cloning. Sometimes it works, sometimes it doesn't. Sometimes you need to increase memory to Git. Recently there are new ways like clone depths and sparse-checkouts.
* Install `vhp` command line tool from `shepherd-tools`
    * `cd` into the `shepherd-tools` repository and run `rake install`.
    * Make sure that `vhp` is  now a command on your PATH - run `vhp` (after restarting your terminal) and you should get a man page. If not, you may need to modify your PATH environment variable to include RubyGems.
* Familiarize yourself in general with:
    * vulnerabilityhistory.org and the kinds of data we present
    * Curation files. Pick a vulnerability on vulnerabilityhistory.org you want to learn about, and find its YML file in the corresponding repo. Take a look at the questions, answers, and info
    * Get to know the websites of the main case studies. Latest list: https://vulnerabilityhistory.org/projects. In particular, find the page where they report where their latest vulnerabilities. For example, ffmpeg reports their vulnerabilities on https://ffmpeg.org/security.html.