require 'csv'
require 'fileutils'
require 'tempfile'
module StringLength
  def stringLength(csvinput, params)
    failureField = params[:column] + " failed the string length check"
    csv = CSV.open(csvinput, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
      if(row[:"#{params[:column]}"] == nil)
        row << failureField
        Common::buildCSV(row, "fail")
      elsif (params[:options][:strLen])
        if (row[:"#{params[:column]}"].size == params[:options][:strLen])
          Common::buildCSV(row, "pass")
        else
          row << failureField
          Common::buildCSV(row, "fail")
        end
      elsif (params[:options][:minLen] != 0 || params[:options][:maxLen] != 0)
        if (params[:options][:maxLen] == 0)
          if (row[:"#{params[:column]}"].size >= params[:options][:minLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        else
          if (row[:"#{params[:column]}"].size >= params[:options][:minLen] && row[:"#{params[:column]}"].size <= params[:options][:maxLen])
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
