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
      timeFormat = "%Y/%d/%m"
      return checkMatch(csvin, timeFormat, params)
    when "MM/DD/YYYY"
      timeFormat = "%m/%d/%Y"
      return checkMatch(csvin, timeFormat, params)
    when "YYYYMMDD"
      timeFormat = "%Y%m%d"
      return checkMatch(csvin, timeFormat, params)
    else
    end
  end


  def checkMatch(csvin, timeFormat, params)
    pickDate = params[:datePicked]
    #convert the picked date from any format to standard format as <DateTime: 2001-02-03T04:05:06+07:00 ...>
    begin
      pickDateTime = DateTime.strptime(pickDate, timeFormat)
    rescue ArgumentError
      return false
    else
      checkRelative(csvin,timeFormat,params,pickDateTime)
    end
  end

  def checkRelative(csvin,timeFormat,params,pickDateTime)
    #get the user defined values from params
    column = params[:column]
    direction = params[:direction]
    pickDate = params[:datePicked]
    #iterate the input file
    csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
      begin
        dateTime = DateTime.strptime(row[:"#{column}"], timeFormat)
      rescue ArgumentError
        row[:failure_reason]  = "Doesn't match the given date format."
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
