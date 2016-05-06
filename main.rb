Dir["./app/businessRules/*.rb"].each {|file| require file }
require "csv"
require "./common/lib.rb"

include Common
include ValueRange

#variables
csvSource = "./data/in/tables/opportunity.csv"

#Set up headers for csvoutput file, based on columns from input
Common::buildHeaders(csvSource)

#apply business rules to input data
params = {column: "amount", minValue: 0.00, maxValue: 180000.00}
ValueRange::applyRule(csvSource, params)
