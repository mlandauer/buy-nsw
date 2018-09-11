module CapybaraTableHelper
  # xpath sourced from http://stackoverflow.com/questions/14745478
  def column_xpath(column)
    "//table/tbody/tr/td[count(//table/thead/tr/th[normalize-space()='#{column}']/preceding-sibling::th)+1]"
  end

end

RSpec.configure do |config|
  config.include CapybaraTableHelper, :type => :feature
end
