require 'csv'
require 'fileutils'
require 'tempfile'
module StringLength
  def stringLength(csvinput, params)
    failureField = params[:column] + " failed the string length check"
    options = params[:options].to_hash
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      row = row.to_hash
      if(row[:"#{params[:column]}"] == nil)
        row << failureField
        Common::buildCSV(row, "fail")
      elsif (options[:strLen])
        if (row[:"#{params[:column]}"].size == options[:strLen])
          Common::buildCSV(row, "pass")
        else
          row << failureField
          Common::buildCSV(row, "fail")
        end
      elsif (options[:minLen] != 0 || options[:maxLen] != 0)
        if (options[:maxLen] == 0)
          if (row[:"#{params[:column]}"].size >= options[:minLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        else
          if (row[:"#{params[:column]}"].size >= options[:minLen] && row[:"#{params[:column]}"].size <= options[:maxLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        end
      else
        row << "Error occured, invalid string length setting."
        Common::buildCSV(row, "fail")
      end
    end
  end
end
