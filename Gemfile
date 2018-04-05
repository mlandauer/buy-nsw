source 'https://rubygems.org'

# There is unfortunately not a single ruby recent-ish version that's going to
# work across both Elastic Beanstalk and Circle CI. Across the last four minor
# releases the versions they support have different patch versions. Sigh.
# So, we'll be using 2.5.0 on Elastic Beanstalk and 2.5.1 on CircleCI and
# disabling the checking of the ruby version here.
#ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'

gem 'aasm'
gem 'carrierwave', '~> 1.0'
gem 'devise'
gem 'dry-validation'
gem 'enumerize'
gem 'reform-rails', '~> 0.1.7'
gem 'textacular', '~> 5.0'
gem 'trailblazer-rails', '~> 2.0.0'

gem 'bootstrap', '~> 4.0.0'
gem 'bootstrap_form', git: 'https://github.com/bootstrap-ruby/bootstrap_form.git',
                      branch: 'master'
gem 'jquery-rails', '~> 4.3.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'jbuilder', '~> 2.5'

gem 'airbrake', '~> 7.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.18.0'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'factory_bot_rails', "~> 4.0"
  gem 'i18n-debug'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
