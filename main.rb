require 'rubygems'
Dir['/home/app/businessRules/*.rb'].each {|file| require file }
require '/home/common/lib.rb'
require "csv"
require 'json'

#include models of business rules and common function files
include Common
include ValueRange
include KnownValues
include RelativeDate
include DataTypeCheck
include DateFormatCheck
include NullEmptyCheck
include StringLength

#parse input JSON for rule parameters
paramSource = "/data/config.json"
jsonFile = File.read(paramSource)
ruleConfig = JSON.parse(jsonFile, :symbolize_names => true)

#Set up headers for csvoutput file, based on columns from input
csvSource = "/data/in/tables/" + ruleConfig[:storage][:input][:tables][0][:destination]
Common::buildHeaders(csvSource)

#apply business rules to input data
requestedRules = ruleConfig[:parameters]
requestedRules.each do |ruleData|
  ruleData[:ruleparameters][:column] = ruleData[:ruleparameters][:column].downcase
    self.send(ruleData[:ruleparameters][:rule], csvSource, ruleData[:ruleparameters])
end
