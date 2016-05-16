module KnownValues

    def knownValues(csvin, params)

        #build array of know values
        values = []
        params[:values].each do |name|
            values << name[:name]
        end

        #parse column to see if value is known
        csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
        csv.each do |row|
            if (values.include? row[:"#{params[:column]}"])
                Common::buildCSV(row.values, "pass")
            else
                row[:failure_reason]  = "#{params[:column]} not a known value"
                Common::buildCSV(row.values, "fail")
            end
        end
    end

end
