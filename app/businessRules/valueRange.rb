module valueRange

    def valueRange.applyRule(csvin, params)
        csvout = []
        CSV.foreach(csvin, {:headers => true, :header_converters => :symbol}) do |row|
            unless (row[params[:column]] >= params[:minValue] && row[params[:column]] <= params[:maxValue])
                row << [failure_reason: "Not in value range"]
                csvout << row.values
            end
        end
        return csvout
    end

end
