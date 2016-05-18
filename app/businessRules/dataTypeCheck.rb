module DataTypeCheck
  require 'date'

  def dataType(csvFile, params)

    #date formats to check
    dateFormats = [
      '%m/%d/%y', '%y/%m/%d', '%d/%m/%y', '%m/%d/%Y', '%Y/%m/%d', '%d/%m/%Y',
      '%b/%d/%y', '%y/%b/%d', '%d/%b/%y', '%b/%d/%Y', '%Y/%b/%d', '%d/%b/%Y',
      '%B/%d/%y', '%y/%B/%d', '%d/%B/%y', '%B/%d/%Y', '%Y/%B/%d', '%d/%B/%Y',
       '%d%m%y', '%m%d%y', '%d%m%Y', '%m%d%Y',
       '%d%b%y', '%b%d%y', '%d%b%Y', '%b%d%Y',
       '%d%B%y', '%B%d%y', '%d%B%Y', '%B%d%Y',
        '%y-%m', '%y-%m-%d', '%d-%m-%y', '%m-%d-%y', '%Y-%m', '%Y-%m-%d', '%d-%m-%Y', '%m-%d-%Y',
        '%y-%b', '%y-%b-%d', '%d-%b-%y', '%b-%d-%y', '%Y-%b', '%Y-%b-%d', '%d-%b-%Y', '%b-%d-%Y',
        '%y-%B', '%y-%B-%d', '%d-%B-%y', '%B-%d-%y', '%Y-%B', '%Y-%B-%d', '%d-%B-%Y', '%B-%d-%Y',
          '%y.%m', '%y.%m.%d', '%d.%m.%y', '%m.%d.%y', '%Y.%m', '%Y.%m.%d', '%d.%m.%Y', '%m.%d.%Y',
          '%y.%b', '%y.%b.%d', '%d.%b.%y', '%b.%d.%y', '%Y.%b', '%Y.%b.%d', '%d.%b.%Y', '%b.%d.%Y',
          '%y.%B', '%y.%B.%d', '%d.%B.%y', '%B.%d.%y', '%Y.%B', '%Y.%B.%d', '%d.%B.%Y', '%B.%d.%Y',
         '%H:%M:%S']
    csv = CSV.open(csvFile, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}

    csv.each do |row|

      case params[:typeofdata]
        # check for alphanumeric
      when 'alphanumeric'
        if(row[:"#{params[:column]}"].match(/^[[:alnum:]]+$/) rescue false)
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = "#{params[:column]} is not alphanumeric"
          Common::buildCSV(row.values, "fail")
        end
        #check for decimal
      when 'decimal'
        #stuff = row[:"#{params[:column]}"]
        #if(stuff.match(/^\d+.\d+$/))
        if(Float(row[:"#{params[:column]}"]) rescue false)
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = " #{params[:column]} is not decimal"
          Common::buildCSV(row.values, "fail")
        end
        #check for integer
      when 'integer'
        if(Integer(row[:"#{params[:column]}"]) rescue false)
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = " #{params[:column]} is not Integer"
          Common::buildCSV(row.values, "fail")
        end
      when 'date'



        parsed_date = nil
        dateFormats.each do |f|
            parsed_date ||= DateTime.strptime(row[:"#{params[:column]}"], f) rescue nil
        end


        if(parsed_date)
          Common::buildCSV(row.values, "pass")
        else
          row[:failure_reason]  = " #{params[:column]} is not a date"
          Common::buildCSV(row.values, "fail")
        end
      end



    end
  end
end
