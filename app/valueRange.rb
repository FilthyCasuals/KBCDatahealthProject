def valuesInRange(csvfile, params)
CSV.foreach("#{Rails.root}/db/data.csv", {:headers => true, :header_converters => :symbol}) do |row|
end
return failedLines
end
