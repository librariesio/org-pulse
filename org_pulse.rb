require 'bundler'
Bundler.require
Dotenv.load

org = 'librariesio'
access_token = ENV['GITHUB_TOKEN']
client = Octokit::Client.new(access_token: access_token, auto_paginate: true)
start_date = '2016-12-01'
end_date = '2016-12-31'

repos = client.org_repos(org)

repos.sort_by(&:stars).reverse.each do |repo|
  issues = client.issues(repo.full_name, state: 'all')
  pull_requests = client.pull_requests(repo.full_name, state: 'all')
  commits = client.commits(repo.full_name, since: start_date, until: end_date) rescue []

  closed_issues = issues.select{|i| i.closed_at && i.closed_at > Date.parse(start_date).to_time && i.closed_at < Date.parse(end_date).to_time }
  merged_pull_requests = pull_requests.select{|i| i.merged_at && i.merged_at > Date.parse(start_date).to_time && i.merged_at < Date.parse(end_date).to_time }

  if commits.length > 0 || merged_pull_requests.length > 0 || closed_issues.length > 0
    puts repo.name
    puts "  #{commits.length} commits" if commits.length > 0
    puts "  #{merged_pull_requests.length} merged pull requests" if merged_pull_requests.length > 0
    puts "  #{closed_issues.length} closed issues" if closed_issues.length > 0
    puts
  end
end
