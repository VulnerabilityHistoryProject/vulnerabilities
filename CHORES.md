# VHP Data Shepherd Chores

These are regular tasks that the data shepherd will need to complete on a weekly basis.

# Getting Started as a Data Shepherd

* Install Ruby 3.2
    * Mac: we recommend `rbenv` via `brew`
    * Windows: use [https://rubyinstaller.org/](https://rubyinstaller.org/)
* Clone various repos:
    * `vulnerabilities` repos - where your main work will be.
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

# Checklist Template

Copy this template into the issue tracker for each project. Replace "fooproj" with the project you're updating.

- [ ] New vulnerabilities
    - [ ] `git pull` on the main source repo (or clone fresh)
    - [ ] `vhp update`
    - [ ] `vhp loadcommits`
    - [ ] `vhp weeklies`
    - [ ] update releases and any other major project news in `projects/fooproj.yml`
- [ ] vhp: if any of the above operations fails, create a bug for it on the `vulnerabiltiies` repository.
- [ ] vhp: `rails data:clear data:all` warnings documented in issues
- [ ] vhp: `rails data:clear data:all` does not break
- [ ] vhp: `vhp` shepherd tools - any bugs or feature ideas?

## `vhp update` - check for New Vulnerabilities

For each case study, look for new vulnerabilities.
  * For some studies, `vhp update` should be all you need. Start there.
  * We haven't migrated ALL of the projects over to `vhp update` though, so you may need to dig through the old `*-vulnerabilities` repos to find a script that pulls new CVEs.
  * Each of our update scripts are a little different in what gets updated - bug IDs, fix commits, etc.
  * If there were no new vulnerabilities recently, no need to do the other things

## Merge PR curations

  * Before starting, run `rails data:dev_all` and make sure it finishes cleanly (warnings are ok).
  * Review the vulnerabilities pull requests over at https://github.com/VulnerabilityHistoryProject/vulnerabilities/pulls
  * For each PR:
    * Check that the PR is passing and does not have a `dont-merge-yet` label on it
    * Check that the PR is intended to merge into `VulnerabilityHistoryProject:dev` (not `master`).
        * If it's not, hit "Edit" in the upper-right and change the base branch to `dev`.
        * It doesn't matter what their branch was called. This will cause the PR to re-run its status checks
    * If the green button shows `Squash and Merge`, press it.
        * You might need to hit `Update Branch`, but usually you won't have to
  * About every 5 PRs or so, go over to your `vulnerability-history` repo and run `rails data:dev_all`
    * Note: this is just `rails data:all` but pulling form the `vulnerablities` dev branch instead.
    * You'll likely get more warnings than normal, but as long as the build finishes without error you're good.

### Tracking Down Exceptions

Suppose you are merging curations and `rails data:dev_all` breaks. Try the simple stuff first:

  * Do you have the latest `vulnerability-history`? Make sure you pull from master and you don't have any edits to it locally that would break things
  * Maybe we updated the database schema. Run `rails db:schema:load`. This fixes issues like "undefined table" and other database stuff.

After that, maybe there's a specific YML that has a problem. Here's an example:

```
rails aborted!
NoMethodError: undefined method `split' for 2.1:Float
C:/code/vulnerability-history/lib/taggers/CVSS_tagger.rb:83:in `block in apply_tags'
C:/code/vulnerability-history/lib/taggers/CVSS_tagger.rb:81:in `apply_tags'
C:/code/vulnerability-history/lib/data_builder.rb:157:in `block in generate_tags'
C:/code/vulnerability-history/lib/data_builder.rb:153:in `each'
C:/code/vulnerability-history/lib/data_builder.rb:153:in `generate_tags'
C:/code/vulnerability-history/lib/tasks/data.rake:47:in `block (2 levels) in <main>'
Tasks: TOP => data:dev_all => data:all => data:build
```

This was an uncaught exception. There's something wrong about a YML, so let's first narrow down which YML. Let's go into `vulnerabilty-history` and temporarily add some exception catchers around that code. You can see the offending code from the stacktrace above is `CVSS_tagger.rb`, so open that file to the line.

Wrap this code with a `begin` and `rescue` block (Ruby's exception handling syntax). This is the one I used for the above error:

```ruby
Vulnerability.all.each do |v|
  begin
    # code does some stuff that results in an error
  rescue => e
    @logger.warn("Exception on #{v.cve}. #{e.message}")
  end
end
```

If `@logger` isn't defined, you can also use `puts` to just print to the console. The main goal here is to figure out which YML it is. We can refine the error handling later.

In the above case, the CVSS was filled in (incorrectly) as a `float` when it should be the full CVSS string. So once we knew the YAMLs, we just fixed the YAMLs and pushed the changes. We also updated the integrity tests in `vulnerabilities` to catch this in the future.



## `vhp loadcommits` - save commit information

**What does this do?** This is going to look through all of our CVEs and finding any git hash that was mentioned in, say, `fixes` or `vccs`. It will then look up those commits in the source repo and save them to `vhp-mining/gitlogs/fooproj.json`.

This is a local operation, but you'll need the source repo of the project cloned and up to date. Most of the projects that's not a problem, but chromium is quite big. You can find the URL of the source repo to clone from the `vulnerabilities/projects/fooproj.yml`.

You'll do this locally, but you'll need the source repo cloned. Most of the projects that's not a problem, but chromium is quite big.

Alternatively, you can use our `artifacts` server or RIT's Research Computing Cluster. Andy can show you how those work. Tends to run much much faster on our servers.

* `cd` to the root of the `vulnerabilities` repo
* Make sure you have the latest source repo. A clean `git clone` can sometimes be easier than `git pull` if the repo is huge
* Run `vhp loadcommits` to update gitlog.json
    * Example run for Struts: `vhp loadcommits --repo ../struts --mining ../vhp-mining --project struts`
* Inspect the output that everything is as you think it is
* Check the size of gitlog.json before and after - did it jump way up in size? There might be a mega-commit in there - file a bug and we'll fix that.
* Commit to the `dev` branch of the vulnerabilties repo
* Push to GitHub
* Make sure the CI builds properly for the specs and `data:all`

## `vhp weeklies`

**What does this do?** This will iterate over every single week since 1991 and calculate various statistics from the source repo. It then populates `vhp-mining/weeklies/CVE-1234-5678.json`.

This can be a slow operation - sometimes overnight. Alternatively, you can use our `artifacts` server or RIT's Research Computing Cluster. Andy can show you how those work. Tends to run much much faster on our servers.

* Make sure you have the latest source repo. A clean `git clone` can sometimes be easier than `git pull` if the repo is huge
* Run `vhp weeklies`, here's an example:
    `vhp weeklies --repo=../tomcat --mining=../vhp-mining --project=tomcat`
* Inspect the output that everything is as you think it is
* Commit to the `dev` branch of the vulnerabilties repo
* Push to GitHub
* Make sure the CI builds properly for the specs and `data:all`

CLI specifics can be found at `vhp help weeklies`

## `vhp nvd`

Sometimes we want to populate NVD information into the YML, such as any built-in CWE or CVSS scores. You can use the `vhp nvd` command to:

* Update ALL vulnerabilities for a project
* Update a SINGLE vulnerability for a project

`vhp nvd` will pull information from the National Vulnerability Database using their RESTful API. You can get an API key for them, but, at the moment (Spring 2023), the API key does not seem to work and we get throttled after a dozen requests or so. So, instead, go to [https://github.com/olbat/nvdcve](https://github.com/olbat/nvdcve) and clone that repository. Give the `--nvd-cve` option and it'll get the info you need.

Details are found in the CLI docs: `vhp nvd -h`

## `vhp new`

If we want to create a new vulnerability and look up basic information as in `vhp nvd`, we can run `vhp new`. See `vhp help new` for options.

## VCC identifying

TBD. You can see how we use archeogit in the migration files if you want to adapt from there.

# Subsystem normalization

**What is this?** We have hundreds of tags called "subsystem", coming from the `subsystems` entry in the curation YML. Curators are asked to name what subsystems are impacted by the vulnerability, and this is a subjective question. So the answers can be all over the place. The goal of this feature is to provide logical groupings of similar vulnerabilities.

**What do I do?** First, you'll need a list of all the subsystem tags currently in use. You can get this from:

* If you have the webapp set up, open up `rails console` and run `Tag.where("shortname LIKE 'subsystem%'").pluck(:name)`
* If you only have access to the website, you can go to the `Tags` page and search for `subsystem`.
* Or, you can go to the "Cloud" tab from the Tags page and copy them from there.

Next, go through the list of subsystems project-by-project and review the list of subsystems that are there.

Apply the following rules:

* All lowercase letters, or any of `@_-` or `0-9`
    * No slashes in the name (e.g. `src/foo` should just be `foo`)
    * A space or two is okay, within reason
    * No commas - multiple subsystems need to be in a YML list (see below)
* 30 characters or less
* Does not have the project name in it (e.g. `struts-foo` should just be `struts`. )
* If multiple subsystems are involved, they need to be specified as separate entries in the YML, using a [YML list](https://en.wikipedia.org/wiki/YAML#Basic_components)
* Nothing way too broad where 80% of vulnerabilities would be in it (e.g. `src`)
* No source code files. A subsystem is larger than a single file.
* This doesn't have to be a directory, but people often infer them from directories
* Not _too similar_ to another subsystem. Use your best judgment here.

When you find a correction, find the original YML file(s) that reference the subsystem and correct them. An easy way to do this is to open up your local `vulnerabilities` repo in VS Code and use `Find in Files` under `Edit` to search for the string you want.

Push your corrections to a new branch and make a pull request.


## Getting SWEN-331 CVEs

* Make sure you have the latest `vulnerabilities` repo
* Make sure it's on the correct branch (e.g. dev or master depending on the situation)
* Make sure you have the latest shepherd tools with `vhp version`
* Check up on how to use `vhp ready` with `vhp help ready`

Run `vhp ready`. Example runs:

`vhp ready --project=kernel --min-vccs=1 --max-level=1`

Once you're happy with the output, pipe it to a CSV file, e.g.

`vhp ready --project=kernel --min-vccs=1 --max-level=1 --full > tmp/kernel_331_cves.csv`

The defaults of fixes and vccs being between 1 and 5 are pretty sensible, so this works:

`vhp ready --project=kernel --full > tmp/kernel_331_cves.csv`


# Useful Tips and Tools

* SSH: for working on the servers, you'll need an SSH client. We recommend MobaXTerm or PuTTY for Windows, or just the terminal for Mac. MobaXTerm has a ton of nice features.
* `artifacts` is a server we have devoted to long computatational tasks.
    * It has a lot of RAM, and the directory `/dev/shm` is a RAMDisk. Note: if artifacts reboots, `/dev/shm` is wiped. So don't put things that need to be permanent there. BUT, IO-heavy operations like with Git and our other scripts will usually go much faster there.
    * Feel free to use `tmux` to detach your session so you can log out and have your session still running
* Get the Windows "Terminal" app from the store - learn more https://github.com/microsoft/terminal
* Research computing (TBD - very useful too)

