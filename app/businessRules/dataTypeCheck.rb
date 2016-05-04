require 'csv'

def DataTypeCheck(csvFile, columnName, dataType)
    @csv = csvfile
    @column = columnName
    @type = dataType

    CSV.foreach(csv, headers:true) do |row|

    end

end
