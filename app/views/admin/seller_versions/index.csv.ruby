csv_builder = lambda do |csv|
  csv << ['id', 'Seller name', 'Status', 'Emails']

  search.results.each do |result|
    row = [
      result.id,
      result.name,
      result.state,
    ]
    row += result.seller.owners.map(&:email)

    csv << row
  end
end

CSV.generate(&csv_builder)
