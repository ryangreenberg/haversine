#!/usr/bin/env ruby -wKU

# This script outputs a text file of cities in the world with a population > 15000
# and their corresponding latitude/longitude

# Benchmark test data from geonames.org
# This work is licensed under a Creative Commons Attribution 3.0 License,
# see http://creativecommons.org/licenses/by/3.0/
# The Data is provided "as is" without warranty or any representation of accuracy, timeliness or completeness.
SOURCE_URL = "http://download.geonames.org/export/dump/cities15000.zip"
SOURCE_FILE = 'cities15000.txt'
OUTPUT_FILE = 'cities_lat_lon.txt'

def download_source_data
  Dir.chdir(File.dirname(__FILE__)) do
    `unzip #{File.basename(SOURCE_URL)}`
  end
end

def extract_city_lat_long_from_line(line)
  line = line.split("\t")
  {
    :city => line[1],
    :lat => line[4],
    :lon => line[5]
  }
end

download_source_data unless File.exist?(SOURCE_FILE)

lat_lons = []
File.open(SOURCE_FILE, 'r') do |f|
  f.each_line do |line|
    lat_lons << extract_city_lat_long_from_line(line)
  end
end

lat_lons = lat_lons.sort_by {|ll| ll[:city]}

File.open(OUTPUT_FILE, 'w') do |f|
  lat_lons.each do |city_lat_lon|
    output = [city_lat_lon[:city], city_lat_lon[:lat], city_lat_lon[:lon]].join("\t")
    f.puts(output)
  end
end