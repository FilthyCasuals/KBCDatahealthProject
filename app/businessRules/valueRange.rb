def valuesInRange(csvinput, csvoutput, params)

    CSV.foreach(csvinput, {:headers => true, :header_converters => :symbol}) do |row|
        unless (row[params[:column]] >= params[:minValue] && row[params[:column]] <= params[:maxValue])
            row << [failure_reason: "Not in value range"]
            csvoutpout << row.values
        end
    end

end
