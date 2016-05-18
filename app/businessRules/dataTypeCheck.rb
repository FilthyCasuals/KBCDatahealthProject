module DataTypeCheck
  require 'DateTime'

  def dataType(csvFile, params)
    dateFormats = ['%m/%d/%Y', '%Y/%m/%d', '%d/%m/%y', '%y%m%d', '%d%m%y', '%m%d%y', '%y', '%y-%m', '%y-%m-%d', '%d-%m-%y', '%m-%d-%y', '%H:%M:%S']
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
