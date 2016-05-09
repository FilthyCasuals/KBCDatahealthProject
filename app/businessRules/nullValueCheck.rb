require 'csv'
require 'fileutils'
require 'tempfile'
module NullEmptyCheck
  def applyRule(csvinput, params)
    failureField = "Failed the null or empty field check"
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      row << row.to_hash

      if (row[:"#{params[:column]}"] == "" || row[:"#{params[:column]}"] == "null" || row[:"#{params[:column]}"] == nil)
        row << failureField
        Common::buildCSV(row, "fail")
      else
        Common::buildCSV(row, "pass")
      end
    end
  end
end
