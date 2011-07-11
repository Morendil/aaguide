require 'sinatra/base'

require './lib/rendering'
require './lib/roadmap'
require './lib/helpers'

class Guide < Sinatra::Base

  def roadmap
    return @roadmap if @roadmap
    @roadmap = Roadmap.new("data")
  end
 
  before do
    expires 500, :public, :must_revalidate
  end

  get '/' do
    erb :index, :layout=>false
  end

  get '/guide/:practice.html' do |practice|
    @practice = roadmap.find_by_id practice
    erb (haml (mustache :practice))
  end

  get '/subway.html' do
    erb :subway, :layout=>false
  end

  get '/alpha.html' do
    @parts = roadmap.all_by_alpha
    haml (mustache :alpha)
  end

  get '/assets/style/style.css' do
    scss :style
  end

  get '/assets/*' do |file|
    send_file File.join('.',request.path)
  end

end
