require 'csv'

def DataTypeCheck(csvFile, columnName, dataType)
    # @csv = csvfile
    # @column = columnName
    # @type = dataType

    csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
    csv.each do |row|
        put case columnName
        when 'id'
          if(row[:"#{columnName}"].match(/^[[:alnum:]]+$/))
              Common::buildCSV(row.values, "pass")
          else
              row[:failure_reason]  = "#{columnName} is not alphanumeric"
              common::buildCSV(row.values, "fail")
          end
        when 'Amount'
          if(row[:"#{columnName}"].to_f.match(/[0-9]\.]+/))
              Common::buildCSV(row.values, "pass")
          else
              row[:failure_reason]  = " #{columnName} is not decimal"
              common::buildCSV(row.values, "fail")
          end
        when 'Probability'
          if(Integer(row[:"#{columnName}"]) rescue false)
              Common::buildCSV(row.values, "pass")
          else
              row[:failure_reason]  = " #{columnName} is not decimal"
              common::buildCSV(row.values, "fail")
          end
    end

end
