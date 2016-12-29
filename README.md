# Org Pulse &#128147;

What's happened on a GitHub Org this month?

## Why is this a thing?

Pulling the data for [Monthly Progress reports](https://hackernoon.com/libraries-io-november-progress-update-150cbc602386#.7vcki7eo2) for https://libraries.io is tedious when there's been lots of activity across many different repositories in an org, this is an attempt to automate some of it

## What state is the project in right now?

The project is a work in progress, not recommended for use!

Check out the open issues for a glimpse of the future: https://github.com/librariesio/org-pulse/issues.

## Development

The source code is hosted at [GitHub](https://github.com/librariesio/org-pulse).
You can report issues/feature requests on [GitHub Issues](https://github.com/librariesio/org-pulse/issues).
For other updates, follow us on Twitter: [@librariesio](https://twitter.com/librariesio).

### Getting Started

New to Ruby? No worries! You can follow these instructions to install a local server, or you can use the included [Vagrant](https://www.vagrantup.com/docs/why-vagrant/) setup.

#### Installing a Local Server

First things first, you'll need to install Ruby 2.4.0. I recommend using the excellent [rbenv](https://github.com/rbenv/rbenv),
and [ruby-build](https://github.com/rbenv/ruby-build):

```bash
brew install rbenv ruby-build
rbenv install 2.4.0
rbenv global 2.4.0
```

Now, let's install the gems from the `Gemfile` ("Gems" are synonymous with libraries in other
languages):

```bash
gem install bundler && rbenv rehash
bundle install
```

Now go and create a [personal access token](https://github.com/settings/tokens) on GitHub with the `repo` scope enabled and add it to `.env`:

```
GITHUB_TOKEN=yourgithubtokenhere
```

Finally you can run the script:

```bash
ruby org_pulse.rb
```

### Note on Patches/Pull Requests

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so we don't break it in a future version unintentionally.
 * Send a pull request. Bonus points for topic branches.

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Copyright

Copyright (c) 2016 Andrew Nesbitt. See [LICENSE](https://github.com/librariesio/org-pulse/blob/master/LICENSE.txt) for details.
