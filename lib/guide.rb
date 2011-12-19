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
    erb :index
  end

  get '/guide/:practice.html' do |practice|
    @practice = roadmap.find_by_id practice
    erb (haml (mustache :practice))
  end

  get '/dash.html' do
    opts = {}
    opts[:parts] = roadmap.all_by_type.map do |part|
      {:group => part[:group]+"s",
       :full => part[:values].select{|v|v["full"]}.length,
       :total => part[:values].length}
    end
    opts[:parts] << {:group => "Total",
      :full => roadmap.all.select{|v|v["full"]}.length,
      :total => roadmap.all.length}
    opts[:parts].each do |each|
      each[:pct] = sprintf( "%0.0f",each[:full]*100.0/each[:total])
    end
    erb (haml (mustache :dash, {}, opts))
  end

  get '/timeline.html' do
    @values = roadmap.all.collect do |each|
      each["sections"].select {|s| s["type"] == "histo"} if each["full"]
    end
    @values = @values.flatten.compact.collect {|s| s["text"]}
    @values = @values.flatten.sort.reject {|l| l.strip == "" || l.strip[0] != "*"}
    erb (markdown (@values.join))
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
