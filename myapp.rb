require 'sinatra'
require 'chunky_png'
require 'http'
require 'json'

get '/activity/:network/:address' do
  content_type = 'image/png'
  png = ChunkyPNG::Image.new(270, 270, ChunkyPNG::Color::TRANSPARENT)

  buckets = getActivityByNetworkAndAddress(params[:network], params[:address])
  bucket_number = 1
  (0..8).each do |j|
    (0..8).each do |i|
      if buckets[bucket_number] > 0
        rand_r = rand(255)
        rand_g = rand(255)
        rand_b = rand(255)
        png.rect(i * 30, j * 30, i * 30 + 30, j * 30 + 30, stroke_color = ChunkyPNG::Color(rand_r, rand_g, rand_b), fill_color = ChunkyPNG::Color(rand_r, rand_g, rand_b))
      end
      bucket_number += 1
    end
  end

  png.save('filename.png', :interlace => true)
  send_file 'filename.png'
end

def getActivityByNetworkAndAddress(network, address)
  endpoint = "api"
  if (network.eql?("rinkeby"))
    endpoint = "api-rinkeby"
  end
  activity = HTTP.get("https://#{endpoint}.etherscan.io/api?module=account&action=txlist&address=#{address}&startblock=0&endblock=99999999&page=1&offset=1000&sort=asc&apikey=#{ENV['ETHERSCAN_API_KEY']}").to_s
  results = JSON.parse(activity)['result']
  start_date = (Date.today - 81).to_time.to_i
  end_date = Date.today.to_time.to_i

  bucket_size = (end_date - start_date) / 81

  activity_hash = Hash.new(0)

  results.map do |a|
    ts = a['timeStamp'].to_i
    next if ts < start_date

    bucket = (ts - start_date) / bucket_size
    activity_hash[bucket] += 1
  end

  activity_hash
end
