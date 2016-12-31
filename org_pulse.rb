require 'bundler'
Bundler.require
Dotenv.load
require 'active_support/core_ext/string/inflections'

# Override org and dates to customize
org = 'librariesio'
start_date = '2016-12-01'
end_date = '2016-12-31'

access_token = ENV['GITHUB_TOKEN']
client = Octokit::Client.new(access_token: access_token, auto_paginate: true)

repos = client.org_repos(org)

total_commits = 0
total_pull_requests = 0
total_issues = 0

puts "# Progress Report for [#{org}](https://github.com/#{org}) between #{start_date} and #{end_date}"

repos.sort_by(&:stars).reverse.each do |repo|
  issues = client.issues(repo.full_name, state: 'all').select{|i| i.pull_request.nil?}
  pull_requests = client.pull_requests(repo.full_name, state: 'all')
  commits = client.commits(repo.full_name, since: start_date, until: end_date) rescue []

  total_commits += commits.length
  total_pull_requests += pull_requests.select{|i| i.created_at && i.created_at > Date.parse(start_date).to_time && i.created_at < Date.parse(end_date).to_time }.length
  total_issues += issues.select{|i| i.created_at && i.created_at > Date.parse(start_date).to_time && i.created_at < Date.parse(end_date).to_time }.length

  closed_issues = issues.select{|i| i.closed_at && i.closed_at > Date.parse(start_date).to_time && i.closed_at < Date.parse(end_date).to_time }
  merged_pull_requests = pull_requests.select{|i| i.merged_at && i.merged_at > Date.parse(start_date).to_time && i.merged_at < Date.parse(end_date).to_time }

  if commits.length > 0 || merged_pull_requests.length > 0 || closed_issues.length > 0
    puts "\n### [#{repo.name}](https://github.com/#{repo.full_name})\n"
    puts "-  [#{commits.length} #{'commit'.pluralize(commits.length)}](https://github.com/#{repo.full_name}/compare/master@%7B#{Date.parse(start_date).to_time.to_i}%7D...master@%7B#{Date.parse(end_date).to_time.to_i}%7D)" if commits.length > 0
    puts "-  [#{closed_issues.length} closed #{'issue'.pluralize(closed_issues.length)}](https://github.com/#{repo.full_name}/issues?utf8=%E2%9C%93&q=is%3Aissue%20closed%3A#{start_date}..#{end_date})" if closed_issues.length > 0
    if merged_pull_requests.any?
      puts "\n#### Merged pull requests\n"
      merged_pull_requests.each do |pr|
        puts "- [#{pr.title}](#{pr.html_url}) by [#{pr.user.login}](#{pr.user.html_url})"
      end
    end
  end
end

puts "\n## Totals\n"
puts "- Commits: #{total_commits}"
puts "- Pull requests: #{total_pull_requests}"
puts "- Issues: #{total_issues}"
