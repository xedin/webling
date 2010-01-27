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

  
set :gremlin, GremlinEvaluator.new
set :views, File.dirname(__FILE__) + '/templates'

get '/' do
  haml :index
end

post '/' do
  code = params[:code].to_java_bytes

  @result = begin 
    options.gremlin.evaluate(ByteArrayInputStream.new(code))
  rescue 
    'Error: ' + $!
  end

  (@result.is_a?(ArrayList) && @result.size == 1) ? @result[0].to_s : @result.to_s 
end

