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

jsonFile = File.read(paramSource)
requestedRules = JSON.parse(jsonFile, :symbolize_names => true)

puts requestedRules
#apply business rules to input data
requestedRules.each do |ruleData|
  ruleData[:ruleparameters][:column] = ruleData[:ruleparameters][:column].downcase
    self.send(ruleData[:ruleparameters][:rule], csvSource, ruleData[:ruleparameters])
end
