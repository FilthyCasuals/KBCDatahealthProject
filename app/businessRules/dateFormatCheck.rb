module DateFormatCheck
require 'date'
  def dateFormatCheck(csvin, params)
    column = params[:column]

      case params[:timeFormat]
      when "hh:mm:ss"
        pattern = /^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/
        return checkMatchFormat(csvin, pattern, column)
      when "YYYY-MM-DD"
        pattern = /^[1-9][0-9]{3}\-((1[0-2])|0([1-9]))\-(([1-2][0-9])|0([1-9])|(3[0-1]))$/
        return checkMatchFormat(csvin, pattern, column)
      when "YYYY-MM"
        pattern = /^[1-9][0-9]{3}\-((1[0-2])|0([1-9]))$/
        return checkMatchFormat(csvin, pattern, column)
      when "YYYY"
        pattern = /^[1-9][0-9]{3}$/
        return checkMatchFormat(csvin, pattern, column)
      when "DD/MM/YYYY"
        pattern = /^(([1-2][0-9])|0([1-9])|(3[0-1]))\/((1[0-2])|0([1-9]))\/[1-9][0-9]{3}$/
        return checkMatchFormat(csvin, pattern, column)
      when "MM/DD/YYYY"
        pattern = /^((1[0-2])|0([1-9]))\/(([1-2][0-9])|0([1-9])|(3[0-1]))\/[1-9][0-9]{3}$/
        return checkMatchFormat(csvin, pattern, column)
      when "YYYYMMDD"
        pattern = /^[1-9][0-9]{3}((1[0-2])|0([1-9]))(([1-2][0-9])|0([1-9])|(3[0-1]))$/
        return checkMatchFormat(csvin, pattern, column)
      when "YYYY/MM/DD"
        pattern = /^[1-9][0-9]{3}\/((1[0-2])|0([1-9]))\/(([1-2][0-9])|0([1-9])|(3[0-1]))$/
        return checkMatchFormat(csvin, pattern, column)
      else
      end

  end


  def checkMatchFormat(csvin,pattern,column)
    csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
      if row[:"#{column}"] == nil
        return
          row[:failure_reason]  = "Doesn't match the given date format."
          Common::buildCSV(row.values, "fail")
      else
        checkFormat = row[:"#{column}"].match(pattern)
        if(checkFormat)
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = "Doesn't match the given date format."
          Common::buildCSV(row.values, "fail")
        end
      end
    end
  end
end
