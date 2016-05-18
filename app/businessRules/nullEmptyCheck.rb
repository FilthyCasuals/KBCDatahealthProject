require 'csv'
require 'fileutils'
require 'tempfile'
module NullEmptyCheck
  def nullEmptyCheck(csvinput, params)
    failureField = "Failed the null or empty field check"
    #row = Array.new
    csv = CSV.open(csvinput, :headers => true, :header_converters => :symbol, :converters => :all).to_a.map {|row| row.to_hash}
    csv.each do |row|
    #CSV.foreach(csvinput, {:encoding => "UTF-8", :headers => true, :header_converters => :symbol, :converters => :all}) do |csvRow|
      #row << csvRow.to_hash
      if(!row.empty?)
        if (row[:"#{params[:column]}"] == "" || row[:"#{params[:column]}"] == nil)
          row[:failureReason] = failureField
          Common::buildCSV(row.values, "fail")
        else
          Common::buildCSV(row.values, "pass")
        end
      end
    end
  end
end
