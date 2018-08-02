csv_builder = lambda do |csv|
  csv << ['ID', 'Name', 'Business contact name', 'Business contact email', 'Status', 'Team members']

  search.results.each do |result|
    row = [
      result.id,
      result.first_version&.name,
      result.first_version&.contact_name,
      result.first_version&.contact_email,
      result.state,
    ] + result.owners.map(&:email)

    csv << row
  end
end

CSV.generate(&csv_builder)
