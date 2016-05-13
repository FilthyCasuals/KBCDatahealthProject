require 'csv'
require 'fileutils'
require 'tempfile'
module StringLength
  def stringLength(csvinput, params)
    puts params
    failureField = params[:column] + " failed the string length check"
    CSV.foreach(csvinput, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      row << row.to_hash
      if(row[:"#{params[:column]}"] == nil){
        row << failureField
        Common::buildCSV(row, "fail")
      }
      elsif (params[:rules][:strLen])
        if (row[:"#{params[:column]}"].size == params[:rules][:strLen])
          Common::buildCSV(row, "pass")
        else
          row << failureField
          Common::buildCSV(row, "fail")
        end
      elsif (params[:rules][:minLen] != 0 || params[:rules][:maxLen] != 0)
        if (params[:rules][:maxLen] == 0)
          if (row[:"#{params[:column]}"].size >= params[:rules][:minLen])
            Common::buildCSV(row, "pass")
          else
            row << failureField
            Common::buildCSV(row, "fail")
          end
        else
          if (row[:"#{params[:column]}"].size >= params[:rules][:minLen] && row[:"#{params[:column]}"].size <= params[:rules][:maxLen])
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
