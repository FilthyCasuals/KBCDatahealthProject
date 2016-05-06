module ValueRange

    def applyRule(csvin, params)
        csv = CSV.open(csvin, :headers => true, :header_converters => :symbol).to_a.map {|row| row.to_hash}
        csv.each do |row|
            if (row[:"#{params[:column]}"].to_f >= params[:minValue] && row[:"#{params[:column]}"].to_f <= params[:maxValue])
                Common::buildCSV(row.values, "pass")
            else
                row[:failure_reason]  = "#{params[:column]} not in value range: #{params[:minValue]} - #{params[:maxValue]}"
                Common::buildCSV(row.values, "fail")
            end
        end
    end

end
