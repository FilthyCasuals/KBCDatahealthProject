require 'csv'
require 'fileutils'
require 'tempfile'

def applyRule(csvinput, params)
  failureField = "Failed the null or empty field check"
  CSV.foreach(csvinput, :headers => true) do |row|
    if (row[params[:column]] == "" || row[params[:column]] == "null" || row[params[:column]] == nil)
      row << failureField
      Common::buildCSV(row, "fail")
    else
      Common::buildCSV(row, "pass")
    end
  end
end
