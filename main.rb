Dir["./app/businessRules/*.rb"].each {|file| require file }
require "csv"
require "./common/lib.rb"

include Common
include ValueRange
include KnownValues
include RelativeDate
#variables
csvSource = "./test/data/in/tables/opportunity.csv"

#Set up headers for csvoutput file, based on columns from input
Common::buildHeaders(csvSource)

#Test data for passed in business rules structure
requestedRules =
[
    [rule: "applyValueRange", params: { column: "amount", minValue: 0.00, maxValue: 180000.00 }],
    [rule: "applyKnownValues", params: { column: "stagename", values: ["Closed Lost", "Closed Won"] }],
    #[rule: "applyRelativeDate", params: {column: "createddate", direction:"future", datePicked:"2011-05-01", timeFormat:"YYYY-MM-DD"}]

]

#apply business rules to input data
requestedRules.each do |ruleData|
    self.send(ruleData[0][:rule], csvSource, ruleData[0][:params])
end
