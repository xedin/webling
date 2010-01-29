require 'java'
require 'rubygems'
require 'sinatra'
require 'haml'

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
#set :gremlin, GremlinEvaluator.new
set :evaluators, {}
set :views, File.dirname(__FILE__) + '/templates'

def evaluator_by_session(id)
  unless options.evaluators[id]
    options.evaluators[id] = GremlinEvaluator.new
  end
  options.evaluators[id]
end

get '/' do
  haml :index
end

post '/' do
  code = params[:code].to_java_bytes

  @result = begin
    session[:id] = rand(917834) unless session.has_key?(:id)
    evaluator_by_session(session[:id]).evaluate(ByteArrayInputStream.new(code))
  rescue 
    'Error: ' + $!
  end

  (@result.is_a?(ArrayList) && @result.size == 1) ? @result[0].to_s : @result.to_s 
end

