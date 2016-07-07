class TransformController < ApplicationController

  require 'rubygems' 
  require 'minimagick'
  require 'json'

  def create
    img_input = params[:image]
    image_file = File.open("image.jpg", "w+")
    image_file.write(Base64.decode64(img_input))

    MiniMagick::Tool::Mogrify.new do |mogrify|
      mogrify.blur("5x3")
      mogrify << "image.jpg"
    end
    
    @picture = Picture.new("image.jpg")

    @respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
  end

  def index
    my_json = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
    puts JSON.pretty_generate(my_json)
  end
end
