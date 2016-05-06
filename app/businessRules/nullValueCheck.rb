require 'csv'
require 'fileutils'
require 'tempfile'

def nullValueCheck(csvinput, csvoutputpass, csvoutputfail, column)
  filepath = "/data/in/tables/"+csvinput
  tableOutPath = "/data/out/tables/"
  passed = TempFile.new(csvoutputpass)
  failed = TempFile.new(csvoutputfail)
  #passed = CSV.open("/data/out/tables/"+csvoutputpass, "wb")
  #failures = CSV.open("/data/out/tables/"+csvoutputfail, "wb")
  failureField = "Failed the null value check"
  CSV.open(passed, w) do |passedCSV|
    CSV.open(failed, w) do |failedCSV|
      CSV.foreach(filepath, :headers => true) do |row|
        if row[column] == "" || row[column] == "null" || row[column] == nil
          #row << "Failed the null value check business rule."
          row << [failureField]
          failed << row
        else
          passed << row
        end
      end
    end
  end
  FileUtils.mv(passed, tableOutPath+csvoutputpass, :force => true)
  FileUtils.mv(failed, tableOutPath+csvoutputfail, :force => true)
end
