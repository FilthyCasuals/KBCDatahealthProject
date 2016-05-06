Dir["./app/businessRules/*.rb"].each {|file| require file }
require "csv"

include ValueRange
#variables
csvsource = "./data/in/tables/opportunity.csv"
csvdestination = "./data/out/tables/destination.csv"

#Set up headers for csvoutput file, based on columns from input
headers = CSV.open(csvsource, 'r') { |csv| csv.first }
headers << "failure_reason"
CSV.open(csvdestination, "wb") do |csvout|
    csvout << headers
end

#apply business rules to input data
params = {column: "amount", minValue: 0.00, maxValue: 10000.00}
failedRows = []
failedRows << ValueRange::applyRule(csvsource, params)
CSV.open(csvdestination, "a+") do |csvout|
    failedRows.each do |row|
        csvout << row
    end
end
