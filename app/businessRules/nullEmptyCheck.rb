require 'csv'
require 'fileutils'
require 'tempfile'
module NullEmptyCheck
  def nullEmptyCheck(csvinput, params)
    failureField = "Failed the null or empty field check"
    row = CSV::row.new
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |csvRow|
      row << csvRow.to_hash
      if (row[:"#{params[:column]}"] == "" || row[:"#{params[:column]}"] == nil)
        row << failureField
        Common::buildCSV(row, "fail")
      else
        Common::buildCSV(row, "pass")
      end
    end
  end
end
