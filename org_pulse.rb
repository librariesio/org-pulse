require 'bundler'
Bundler.require
Dotenv.load
require 'active_support/core_ext/string/inflections'

org = 'librariesio'
access_token = ENV['GITHUB_TOKEN']
client = Octokit::Client.new(access_token: access_token, auto_paginate: true)
start_date = '2016-12-01'
end_date = '2016-12-31'

repos = client.org_repos(org)

repos.sort_by(&:stars).reverse.first(10).each do |repo|
  issues = client.issues(repo.full_name, state: 'all').select{|i| i.pull_request.nil?}
  pull_requests = client.pull_requests(repo.full_name, state: 'all')
  commits = client.commits(repo.full_name, since: start_date, until: end_date) rescue []

  closed_issues = issues.select{|i| i.closed_at && i.closed_at > Date.parse(start_date).to_time && i.closed_at < Date.parse(end_date).to_time }
  merged_pull_requests = pull_requests.select{|i| i.merged_at && i.merged_at > Date.parse(start_date).to_time && i.merged_at < Date.parse(end_date).to_time }

  if commits.length > 0 || merged_pull_requests.length > 0 || closed_issues.length > 0
    puts "### [#{repo.name}](https://github.com/#{repo.full_name})"
    puts "-  [#{commits.length} #{'commit'.pluralize(commits.length)}](https://github.com/#{repo.full_name}/compare/master@%7B#{Date.parse(start_date).to_time.to_i}%7D...master@%7B#{Date.parse(end_date).to_time.to_i}%7D)" if commits.length > 0
    puts "-  [#{closed_issues.length} closed  #{'issue'.pluralize(closed_issues.length)}](https://github.com/#{repo.full_name}/issues?utf8=%E2%9C%93&q=is%3Aissue%20closed%3A#{start_date}..#{end_date})" if closed_issues.length > 0
    puts
    if merged_pull_requests.any?
      puts "#### Merged pull requests"
      merged_pull_requests.each do |pr|
        puts "- [#{pr.title}](#{pr.html_url}) by [#{pr.user.login}](#{pr.user.html_url})"
      end
      puts
    end
  end
end
