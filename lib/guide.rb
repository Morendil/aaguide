require 'sinatra/base'

require './lib/rendering'
require './lib/roadmap'

class Guide < Sinatra::Base

  before do
    expires 500, :public, :must_revalidate
  end

  get '/' do
    erb :index, :layout=>false
  end

  get '/subway.html' do
    erb :subway, :layout=>false
  end

  get '/alpha.html' do
    @parts = Roadmap.new("data").all_by_alpha
    haml (mustache :alpha)
  end

  get '/assets/*' do |file|
    send_file File.join('.',request.path)
  end

end
