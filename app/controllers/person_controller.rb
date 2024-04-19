class PersonController < ApplicationController
    def person
      require "faker"
      
      @query = params["q"]

      if @query.blank?
        dataNotFound
      else
        num = generateNumberFromName(@query)
        Faker::Config.random = Random.new(num)
  
        # In a real setting, this data would be populated via some public register record in a database or similar
        @personInfo = {
          "education" => Faker::Demographic.educational_attainment,
          "maritalStatus" => Faker::Demographic.marital_status,
          "fieldOfWork" => Faker::Job.field,
          "jobTitle" => Faker::Job.title,
          "employmentType" => Faker::Job.employment_type,
          "vehicle" => Faker::Vehicle.make_and_model
        }
      end
    end

    # Generates number from name string to use with faker for deterministic randomness - demo purposes only
    def generateNumberFromName(name)
      numberString = ""
      nameArr = name.split(" ")

      nameArr.each do |nameSegment|
        nameSegment.each_char.with_index do |char, index|
          break if index >= 3
          numberString += char.ord.to_s
        end
      end

      return numberString.to_i
    end
  end