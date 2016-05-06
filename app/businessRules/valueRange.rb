module ValueRange

    def applyRule(csvin, params)
        csvout = []
        # CSV.foreach(csvin, {:headers => true, :header_converters => :symbol}) do |row|
        #     unless (row[params[:column]] >= params[:minValue] && row[params[:column]] <= params[:maxValue])
        #         row << [failure_reason: "Not in value range"]
        #         csvout << row.values
        #     end
        # end
        csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
        csv.each do |row|
            unless (row[:"#{params[:column]}"].to_f >= params[:minValue] && row[:"#{params[:column]}"].to_f <= params[:maxValue])
                row[:failure_reason]  = "Not in value range"
                csvout << row.values
            end
        end
        print csvout
        return csvout
    end

end
