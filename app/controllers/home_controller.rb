class HomeController < ApplicationController
  def index
    require "csv"

    @skip = (params["skip"].presence || 0).to_i
    @take = (params["take"].presence || 10).to_i

    csvRows = CSV.parse(File.read("data/data.csv"), headers: true, header_converters: lambda { |header| header.strip })

    @data = []

    csvRows.each do |row|
      name = row["first_name"].strip + " " + row["last_name"].strip
      address = row["address"].strip
      @data << {"name" => name, "address" => address}
    end

    @maxLength = @data.length
    @numPages = (@maxLength / @take.to_f).ceil

    if @skip >= @maxLength || @skip < 0
      @skip = 0
    end

    @data = @data.slice(@skip, @take)
  end
end
