module ValueRange

    def applyRule(csvin, params)
        csvout = []
        csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
        csv.each do |row|
            unless (row[:"#{params[:column]}"].to_f >= params[:minValue] && row[:"#{params[:column]}"].to_f <= params[:maxValue])
                row[:failure_reason]  = "#{params[:column]} not in value range: #{params[:minValue]} - #{params[:maxValue]}"
                csvout << row.values
            end
        end
        return csvout
    end

end
