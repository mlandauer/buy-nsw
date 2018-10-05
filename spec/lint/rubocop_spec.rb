# we run rubocop in a spec to allow quick integration with circleci (which already runs all specs)
# https://gist.github.com/djburdick/5104d15f612c15dde65f
require "spec_helper"

RSpec.describe "Check the current codebase can pass lint checks" do
  before do
    @report = `rubocop`
  end

  it { expect(@report.match("Offenses")).to be_nil, "Rubocop offenses found.\n#{@report}" }
end
