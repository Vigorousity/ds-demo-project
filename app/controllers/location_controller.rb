class LocationController < ApplicationController
    def location
      require "net/http"
      
      geocodeApiUrl = "https://geocoding.geo.census.gov/geocoder/geographies/onelineaddress?address=%s&benchmark=Public_AR_Census2020&vintage=Census2020_Census2020&layers=10&format=json"

      censusVariables = [
        "NAME",  
        "DP02_0124E",   # Total Population    
        "DP03_0062E",   # Median Income
        "DP03_0119PE",  # % Families and People Whose Income in the past 12 months is below the poverty level
        "DP02_0067PE",  # Educational Attainment (25 years and over, high school graduate or higher, %)
        "DP02_0016E",   # Average Household Size
        "DP02_0007E",   # Single Male Householder With Children
        "DP02_0011E",   # Single Female Householder With Children
        "DP02_0114PE",  # Language Spoken At Home Other Than English (5 years and over, %)
        "DP02_0154PE",  # Households With Internet Subscription (%)
        "DP03_0009PE",  # Unemployment Rate (%)
      ]
      indexMap = createIndexMap(censusVariables)

      censusApiUrl = "https://api.census.gov/data/2022/acs/acs5/profile?get=" + censusVariables.join(",") + "&for=tract:%s&in=state:%s county:%s"

      @locationInfo = {
        "censusBlockName" => "",
        "totalPop" => 0,
        "medianIncome" => 0,
        "incomePoverty" => 0,
        "education" => 0,
        "avgHouseholdSize" => 0,
        "singleMaleWithChildren" => 0,
        "singleFemaleWithChildren" => 0,
        "homeLanguageNotEnglish" => 0,
        "internetSubscription" => 0,
        "unemploymentRate" => 0
      }

      @query = params["q"]
      url = URI.parse(geocodeApiUrl % [@query])
      result = Net::HTTP.get(url)

      resultDecoded = ActiveSupport::JSON.decode(result)
      addressMatch = resultDecoded["result"]["addressMatches"][0]
      if addressMatch.blank?
        dataNotFound
      else
        censusBlock = addressMatch["geographies"]["Census Blocks"][0]
        censusResult = Net::HTTP.get(URI(censusApiUrl % [censusBlock["TRACT"], censusBlock["STATE"], censusBlock["COUNTY"]]))

        if censusResult
          censusResultDecoded = ActiveSupport::JSON.decode(censusResult)
          censusData = censusResultDecoded[1]

          if censusData
            @locationInfo["censusBlockName"] = censusData[indexMap["NAME"]].gsub(";", ",")
            @locationInfo["totalPop"] = censusData[indexMap["DP02_0124E"]].to_i
            @locationInfo["medianIncome"] = censusData[indexMap["DP03_0062E"]].to_i
            @locationInfo["incomePoverty"] = censusData[indexMap["DP03_0119PE"]].to_f
            @locationInfo["education"] = censusData[indexMap["DP02_0067PE"]].to_f
            @locationInfo["avgHouseholdSize"] = censusData[indexMap["DP02_0016E"]].to_f
            @locationInfo["singleMaleWithChildren"] = censusData[indexMap["DP02_0007E"]].to_i
            @locationInfo["singleFemaleWithChildren"] = censusData[indexMap["DP02_0011E"]].to_i
            @locationInfo["homeLanguageNotEnglish"] = censusData[indexMap["DP02_0114PE"]].to_f
            @locationInfo["internetSubscription"] = censusData[indexMap["DP02_0154PE"]].to_f
            @locationInfo["unemploymentRate"] = censusData[indexMap["DP03_0009PE"]].to_f
          end
        end
      end
    end

    # Index mapping of variables to allow use of variable name instead of keeping track of indexes
    def createIndexMap(arr)
      indexMap = {}

      arr.each_with_index do |key, index|
        indexMap[key] = index
      end

      return indexMap
    end
  end