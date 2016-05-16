module Common

    @passDestination = "/data/out/tables/out.c-main.passDestination.csv"
    @failDestination = "/data/out/tables/out.c-main.failDestination.csv"

    def buildHeaders(csv)
        #get headers for output
        headers = CSV.open(csv, 'r') { |csv| csv.first }
        #build passing data file
        CSV.open(@passDestination, "wb") do |csvout|
            csvout << headers
        end

        #add Failure_Reason to headers
        headers << "Failure_Reason"
        #build failing data file
        CSV.open(@failDestination, "wb") do |csvout|
            csvout << headers
        end
    end

    #send data to appropriate output file
    def buildCSV(row, state)
        if (state == "pass")
            csvDestination = @passDestination
        elsif (state == "fail")
            csvDestination = @failDestination
        end
        CSV.open(csvDestination, "a") do |csvout|
            csvout << row
        end
    end

end
