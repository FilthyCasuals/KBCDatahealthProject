def DateFormatCheck(csvin, params)

  case params[:timeFormat]
  when "hh:mm:ss"
    m = /^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/
    return checkMatch(csvin, m)
  when "YYYY-MM-DD"
    m = /^[0-9]{4}\-((1[0-2])|0([1-9]))\-(([1-2][0-9])|0([1-9])|(3[0-1]))$/
    return checkMatch(csvin, m)
  when "YYYY-MM"
    m = /^[0-9]{4}\-((1[0-2])|0([1-9]))$/
    return checkMatch(csvin, m)
  when "YYYY"
    m = /^[0-9]{4}$/
    return checkMatch(csvin, m)
  when "DD/MM/YYYY"
    m = /^(([1-2][0-9])|0([1-9])|(3[0-1]))\/((1[0-2])|0([1-9]))\/[0-9]{4}$/
    return checkMatch(csvin, m)
  when "MM/DD/YYYY"
    m = /^((1[0-2])|0([1-9]))\/(([1-2][0-9])|0([1-9])|(3[0-1]))\/[0-9]{4}$/
    return checkMatch(csvin, m)
  else #default case
  end
end


def checkMatch(csvin,m)
  csvout = []
  CSV.foreach(csvin, {:headers => true, :header_converters => :symbol}) do |row|
    checkFormat = row[params[:column]].match(m)
    unless checkFormat
      row << [failure_reason: "Doesn't match the given date format."]
      csvout << row.values
  end
  return csvout
end
