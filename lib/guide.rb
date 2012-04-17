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

  def comments_on code
    @code = code
    @comments = erb :comments, :layout => false
  end

  get '/' do
    comments_on :index
    erb :index
  end

  get '/guide/:practice.html' do |practice|
    comments_on practice
    @practice = roadmap.find_by_id practice
    erb haml (mustache :practice)
  end

  get '/timeline.html' do
    @values = roadmap.all.collect do |each|
      each["sections"].select {|s| s["type"] == "histo"} if each["full"]
    end
    @values = @values.flatten.compact.collect {|s| s["text"]}
    @values = @values.flatten.sort.reject {|l| l.strip == "" || l.strip[0] != "*"}
    body = erb (markdown (@values.join)), :layout => :timeline
    erb body
  end

  get '/subway.html' do
    @variant = :bare
    erb :subway
  end

  get '/alpha.html' do
    @parts = roadmap.all_by_alpha
    haml (mustache :alpha)
  end

  helpers do
    def finish inner
     layout = @variant || :central
     erb inner, :layout => layout
    end
  end

  get '/assets/style/style.css' do
    scss :style
  end

  get '/assets/*' do |file|
    send_file File.join('.',request.path)
  end

end
