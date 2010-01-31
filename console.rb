require 'java'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'functions'

java_import java.util.ArrayList
java_import java.io.ByteArrayInputStream

begin
  java_import com.tinkerpop.gremlin.GremlinEvaluator
  java_import com.tinkerpop.gremlin.statements.EvaluationException
  java_import com.tinkerpop.gremlin.statements.SyntaxException
  
rescue 
  print "Please install gremlin standalone in your JRuby CLASS_PATH\n"
  exit 1
end

enable :sessions

set :evaluators, {}
set :views, File.dirname(__FILE__) + '/templates'

get '/' do
  haml :index
end

get '/visualize' do
  graph   = params[:g] || '$_g'
  command = "g:json(.)".to_java_bytes
  result  = JSON(evaluate_code(command))

  begin
    v = {}
    v[:id]   = result['_id']
    v[:data] = result['properties']
    v[:children] = children(graph, result['outE'], result['inE']) 
  rescue
    v = 'Could not visualize graph ' + graph
  end

  v.to_json
end

post '/' do
  code = params[:code].to_java_bytes
  evaluate_code(code)  
end

