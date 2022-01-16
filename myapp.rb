require 'sinatra'
require 'chunky_png'

get '/' do
  content_type = 'image/png'
  png = ChunkyPNG::Image.new(270, 270, ChunkyPNG::Color::TRANSPARENT)
  rand_r = rand(255)
  rand_g = rand(255)
  rand_b = rand(255)
  png.rect(0, 0, 40, 40, stroke_color = ChunkyPNG::Color(rand_r, rand_g, rand_b), fill_color = ChunkyPNG::Color(rand_r, rand_g, rand_b))
#  send_file png.write
  png.save('filename.png', :interlace => true)
  send_file 'filename.png'
end
