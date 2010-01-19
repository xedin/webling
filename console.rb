require 'java'
require 'rubygems'
require 'sinatra'
require 'haml'

java_import java.io.StringBufferInputStream

begin
  java_import com.tinkerpop.gremlin.GremlinEvaluator
  java_import com.tinkerpop.gremlin.statements.EvaluationException
  java_import com.tinkerpop.gremlin.statements.SyntaxException
rescue 
  print "Please install gremlin standalone in your JRuby CLASS_PATH\n"
  exit 1
end

get '/' do
  haml :index
end

post '/' do
  gremlin = GremlinEvaluator.new
  stream  = StringBufferInputStream.new(params[:code])

  @result = begin 
    gremlin.evaluate(stream)
  rescue 
    'Error: ' + $!
  end

  haml :index
end

