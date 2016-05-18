require 'csv'
require 'fileutils'
require 'tempfile'
module StringLength
  def stringLength(csvinput, params)
    failureField = "Column " + params[:column] + " failed the string length check: "
    options = params[:options].to_hash
    row = Hash.new
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |csvRow|
      row << csvRow.to_hash
      #if the row doesn't exist
      if(row.empty?)
        next
      #if the column doesn't exist
      elsif(row[:"#{params[:column]}"] == nil)
        break
      #if the strLen parameter has been passed in
      elsif (options[:strLen] != nil && options[:strLen] != 0)
        if (row[:"#{params[:column]}"].size == options[:strLen])
          Common::buildCSV(row, "pass")
        else
          row << failureField + "field length is not " + options[:strLen]
          Common::buildCSV(row, "fail")
        end
      #if the minLen or maxLen parameters have been passed in
      elsif ((options[:minLen] != nil && options[:minLen] != 0) || (options[:maxLen] != nil && options[:maxLen] != 0))
        #if maxLen hasn't been set
        if (options[:maxLen] == 0)
          if (row[:"#{params[:column]}"].size >= options[:minLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField + "field length is less than " + options[:minLen]
            Common::buildCSV(row, "fail")
          end
        #if maxLen has been set
        else
          if (row[:"#{params[:column]}"].size >= options[:minLen] && row[:"#{params[:column]}"].size <= options[:maxLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField + "field length is not between " + options[:minLen] + " and " + options[:maxLen]
            Common::buildCSV(row, "fail")
          end
        end
      #if the parameters have not been set correctly
      else
        row << "Error occured, invalid string length setting."
        Common::buildCSV(row, "fail")
      end
    end
  end
end
