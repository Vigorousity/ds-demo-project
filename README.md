## Project Overview

This project has been created for demo purposes. 

A CSV is used to populate a table of names and addresses. Clicking on a name will display additional information about that person. Clicking on an address will display additional information about the area that address is located in. The intent is to present useful data that can be used to make informed decisions.

The data for people is generated using the [faker library](https://github.com/faker-ruby/faker), and the data for addresses is pulled from the [US census](https://www.census.gov/programs-surveys/acs) API using the latest ACS 5-year survey profile dataset, which at the time of writing this is 2022.

## Installation Instructions

#### 1. Install Node.js (https://nodejs.org/en)

#### 2. Install Ruby (https://rubyinstaller.org/downloads/)
- This project uses version 3.2.3

#### 3. Install SQLite3 (https://www.sqlite.org/index.html)
- A useful guide to assist with this installation can be found [here](https://www.tutorialspoint.com/sqlite/sqlite_installation.htm)

#### 4. Install Rails from your terminal of choice using the `gem install` command
```shell
gem install rails
```

#### 5. Clone the repository
```shell
git clone XXXXXXX
cd XXXX
```

#### 6. Within the project's directory, run `bundle install`
```shell
bundle install
```

#### 7. Start the local server
```shell
rails s
```

#### 8. Open the web application in your browser
- This is typically found at the following url: http://localhost:3000