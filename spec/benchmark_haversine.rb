$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'benchmark'
require 'haversine'

OUTPUT_FILE = 'cities_lat_lon.txt'
unless File.exist?(OUTPUT_FILE)
  require 'download_lat_lon_data'
end

# Load lat/lon for all cities
lat_lons = []
File.open(OUTPUT_FILE, 'r') do |f|
  f.each_line do |line|
    line = line.split("\t")
    lat_lons << [ line[1].to_f, line[2].to_f ]
  end
end

# Create test pairs
test_pairs = []
lat_lons.each_slice(2) { |city_pair| test_pairs << city_pair.flatten if city_pair.size == 2}

Benchmark.bm do |x|
  x.report("Haversine.distance") do
    100.times do
      test_pairs.each do |test_pair|
        Haversine.distance(*test_pair)
      end
    end
  end
end