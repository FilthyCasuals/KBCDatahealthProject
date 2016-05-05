Dir["/app/businessRules/*.rb"].each {|file| require file }
require "csv"

headers = CSV.open(csvfile, 'r') { |csv| csv.first }
headers << "failure_reason"

CSV.open("/data/out/tables/valueRange.csv", "wb") do |csv|
    csv << headers
end
