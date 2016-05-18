require 'csv'
require 'fileutils'
require 'tempfile'
module NullEmptyCheck
  def nullEmptyCheck(csvinput, params)
    failureField = "Failed the null or empty field check"
    #row = Array.new
    csv = csv.open(csvinput, {:encoding => "UTF-8", :headers => true, :header_converters => :symbol, :converters => :all}).to_a.map {|row| row.to_hash}
    csv.each do |row|
    #CSV.foreach(csvinput, {:encoding => "UTF-8", :headers => true, :header_converters => :symbol, :converters => :all}) do |csvRow|
      #row << csvRow.to_hash
      if(row != nil)
        if (row[:"#{params[:column]}"] == "" || row[:"#{params[:column]}"] == nil)
          row << failureField
          Common::buildCSV(row, "fail")
        else
          Common::buildCSV(row, "pass")
        end
      end
    end
  end
end
