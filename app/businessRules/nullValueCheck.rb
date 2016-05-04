require 'csv'
def nullValueCheck(table, column)
  filepath = "data/in/tables".table.".csv"
  writer = CSV.open("data/out/tables".table."failures.csv", "wb")
  CSV.foreach(filepath, :headers => true) do |row|
    if row[column] == "" || row[column] == "null" || row[column] == nil
      #row << "Failed the null value check business rule."
      writer << row
    end
  end
end
