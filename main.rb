require 'rubygems'
Dir["./app/businessRules/*.rb"].each {|file| require file }
require "./common/lib.rb"
require "csv"
require 'json'

include Common
include ValueRange
include KnownValues
include RelativeDate
include DataTypeCheck
include DateFormatCheck
include NullEmptyCheck
include StringLength

#variables
csvSource = "./test/data/in/tables/opportunity.csv"
paramSource = "./test/data/in/files/sample.json"

#Set up headers for csvoutput file, based on columns from input
Common::buildHeaders(csvSource)

#apply business rules to input data
requestedRules.each do |ruleData|
    self.send(ruleData[0][:rule], csvSource, ruleData[0][:params])
end
