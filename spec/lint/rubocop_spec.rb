# we run rubocop in a spec to allow quick integration with circleci (which already runs all specs)
# https://gist.github.com/djburdick/5104d15f612c15dde65f
require "spec_helper"

RSpec.describe "Check that the files we have changed pass lint checking" do
  before do
    current_sha = `git rev-parse --verify HEAD`.strip!
    files = `git diff master #{current_sha} --name-only | grep .rb`
    files.tr!("\n", " ")
    @report = `rubocop #{files}`
    puts "Report: #{@report}"
  end

  it { expect(@report.match("Offenses")).to be_nil, "Rubocop offenses found.\n#{@report}" }
end
