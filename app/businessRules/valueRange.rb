module ValueRange

    def valueRange(csvin, params)
        #If passed values that are not floats, rule is skipped. Needs some form of feedback in future development
        #if (params[:minValue].is_a?(Float) && params[:maxValue].is_a?(Float))
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
    #end

end
