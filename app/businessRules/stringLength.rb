require 'csv'
require 'fileutils'
require 'tempfile'
module StringLength
  def applyRule(csvinput, params)
    failureField = "Failed the string length check"
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      row << row.to_hash
      if (params[:strLen])
        if (row[:"#{params[:column]}"].size == params[:strLen])
          Common::buildCSV(row, "pass")
        else
          row << failureField
          Common::buildCSV(row, "fail")
        end
      elsif (params[:minLen] != 0 || params[:maxLen] != 0)
        if (params[:maxLen] == 0)
          if (row[:"#{params[:column]}"].size >= params[:minLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        else
          if (row[:"#{params[:column]}"].size >= params[:minLen] && row[:"#{params[:column]}"].size <= params[:maxLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        end
      else
        puts "Error occured, invalid string length setting."
      end
    end
  end
end