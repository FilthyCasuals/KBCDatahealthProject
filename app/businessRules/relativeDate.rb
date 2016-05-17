module RelativeDate
require 'date'
  def relativeDate(csvin, params)

    case params[:timeFormat]
    when "YYYY-MM-DD"
      timeFormat = "%Y-%m-%d"
      return checkMatch(csvin, timeFormat, params)
    when "YYYY-MM"
      timeFormat = "%Y-%m"
      return checkMatch(csvin, timeFormat, params)
    when "YYYY"
      timeFormat = "%Y"
      return checkMatch(csvin, timeFormat, params)
    when "DD/MM/YYYY"
      timeFormat = "%d/%m/%Y"
      return checkMatch(csvin, timeFormat, params)
    when "YYYY/MM/DD"
      timeFormat = "%Y/%m/%d"
      return checkMatch(csvin, timeFormat, params)
    when "MM/DD/YYYY"
      timeFormat = "%m/%d/%Y"
      return checkMatch(csvin, timeFormat, params)
    when "YYYYMMDD"
      timeFormat = "%Y%m%d"
      return checkMatch(csvin, timeFormat, params)
    else
      return false
    end
  end


  def checkMatch(csvin, timeFormat, params)
    #get the user defined values from params
    column = params[:column]
    pickDate = params[:datePicked]
    direction = params[:direction]

    #convert the picked date from any format to standard format as <DateTime: 2001-02-03T04:05:06+07:00 ...>
    begin
      if(timeFormat == '%Y-%m-%d')
        pattern = /^[1-9][0-9]{3}\-((1[0-2])|0([1-9]))\-(([1-2][0-9])|0([1-9])|(3[0-1]))$/
        check = pickDate.match(pattern)
        if(check)
          pickDateTime = DateTime.strptime(pickDate, timeFormat)
        else
          return false
        end
      else
        pickDateTime = DateTime.strptime(pickDate, timeFormat)
      end
    rescue ArgumentError
      return false
    else
      checkRelative(csvin,timeFormat,direction,pickDate,column,pickDateTime)
    end
  end

  def checkRelative(csvin,timeFormat,direction,pickDate,column,pickDateTime)

    #iterate the input file
    csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
      begin
        dateTime = DateTime.strptime(row[:"#{column}"], timeFormat)
      rescue ArgumentError
        row[:failure_reason]  = "This #{column} is not #{direction} of #{pickDate}."
        Common::buildCSV(row.values, "fail")
      else
        #check if it's in the past/future relative to picked date
        if dateTime <= pickDateTime && direction == "past"
          Common::buildCSV(row.values, "pass")
        elsif dateTime >= pickDateTime && direction == "future"
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = "This #{column} is not #{direction} of #{pickDate}."
          Common::buildCSV(row.values, "fail")
        end
      end

    end
  end


end
