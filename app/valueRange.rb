def valuesInRange(csvfile, params)
    CSV.foreach(csvfile, {:headers => true, :header_converters => :symbol}) do |row|
        if (params[:column] >= params[:minValue] && params[:column] <= params[:maxValue])
        end
    end
    return failedLines
end
