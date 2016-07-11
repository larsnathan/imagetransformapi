class TransformController < ApplicationController

  require 'rubygems' 
  require 'mini_magick'
  require 'open-uri'
  require 'cloudinary'
  skip_before_action :verify_authenticity_token

  def index
    my_json = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
    render json: JSON.pretty_generate(my_json)
  end

  def create
    # img1_url = params[:picture1]
    # open('image1.jpg', 'wb') do |file|
    #   file << open(img1_url).read
    # end

    # img2_url = params[:picture2]
    # open('image2.jpg', 'wb') do |file|
    #   file << open(img2_url).read
    # end

    # first_image = MiniMagick::Image.new("image1.jpg")
    # second_image = MiniMagick::Image.new("image2.jpg")

    # result = first_image.composite(second_image) do |c|
    #   c.compose "Over"    # OverCompositeOp
    #   c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
    # end
    # result.write "output.jpg"

    image_url = params[:picture]
    open('image.jpg', 'wb') do |file|
      file << open(image_url).read
    end

    MiniMagick::Tool::Mogrify.new do |mogrify|
      mogrify.blur("5x3")
      mogrify << "image.jpg"
    end

    auth = {
      cloud_name: "natekronos",
      api_key: "529551768137712",
      api_secret: "86j1wf0r8JgITaKKdxgLDMnLNWY"
    }
    image_hash = Cloudinary::Uploader.upload('image.jpg', auth)
    image_url = image_hash["url"]
    render json: { :image_url => image_url }
  end
end