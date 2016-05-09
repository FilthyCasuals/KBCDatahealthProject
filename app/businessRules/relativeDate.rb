module RelativeDate
  #test
  #params2 = {column: "createddate", direction:"future", relativeTime:"2011-05-01", timeFormat:"YYYY-MM-DD"}
  #RelativeDate::applyRule(csvSource, params2)
require 'date'
  def applyRule(csvin, params)
    column = params[:column]
    pickDate = params[:relativeTime]
    direction = params[:direction]
    case params[:timeFormat]
    when "hh:mm:ss"
      pattern = /^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/
      timeFormat = "%H:%M:%S"
      return checkMatch(csvin, pattern, column, timeFormat)
    when "YYYY-MM-DD"
      pattern = /^[0-9]{4}\-((1[0-2])|0([1-9]))\-(([1-2][0-9])|0([1-9])|(3[0-1]))$/
      timeFormat = "%Y-%m-%d"
      return checkMatch(csvin, pattern, column, timeFormat, pickDate, direction)
    when "YYYY-MM"
      pattern = /^[0-9]{4}\-((1[0-2])|0([1-9]))$/
      timeFormat = "%Y-%m"
      return checkMatch(csvin, pattern, column, timeFormat)
    when "YYYY"
      timeFormat = "%Y"
      pattern = /^[0-9]{4}$/
      return checkMatch(csvin, pattern, column, timeFormat)
    when "DD/MM/YYYY"
      pattern = /^(([1-2][0-9])|0([1-9])|(3[0-1]))\/((1[0-2])|0([1-9]))\/[0-9]{4}$/
      timeFormat = "%d/%m/%Y"
      return checkMatch(csvin, pattern, column, timeFormat)
    when "MM/DD/YYYY"
      pattern = /^((1[0-2])|0([1-9]))\/(([1-2][0-9])|0([1-9])|(3[0-1]))\/[0-9]{4}$/
      timeFormat = "%m/%d/%Y"
      return checkMatch(csvin, pattern, column, timeFormat)
    when "YYYYMMDD"
      pattern = /^[0-9]{4}((1[0-2])|0([1-9]))(([1-2][0-9])|0([1-9])|(3[0-1]))$/
      timeFormat = "%Y%m%d"
      return checkMatch(csvin, pattern, column, timeFormat)
    else
    end
  end


  def checkMatch(csvin,pattern,column, timeFormat, pickDate, direction)

    csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
      dateTime = DateTime.strptime(row[:"#{column}"], timeFormat)
      pickDateTime = DateTime.strptime(pickDate, timeFormat)
      checkFormat = row[:"#{column}"].match(pattern)
      if(checkFormat)
        #check if it's in the past/future relative to date
          if dateTime <= pickDateTime && direction == "past"
            Common::buildCSV(row.values, "pass")
          elsif dateTime >= pickDateTime && direction == "future"
            Common::buildCSV(row.values, "pass")
          else
            row[:failure_reason]  = "The given date is not in the #{direction}."
            Common::buildCSV(row.values, "fail")
          end
      else
        row[:failure_reason]  = "Doesn't match the given date format."
        Common::buildCSV(row.values, "fail")
      end
    end
  end
end
