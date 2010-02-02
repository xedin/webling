require 'json'
require 'digest/sha1'

def generate_session_id
  Digest::SHA1.hexdigest(rand(917834).to_s + request.ip)
end

def evaluator_by_session
  unless session.has_key?(:id)
    session[:id] = generate_session_id
  end

  id = session[:id]
  unless options.evaluators[id]
    options.evaluators[id] = GremlinEvaluator.new
  end
  options.evaluators[id]
end

def evaluate_code(code)
  @result = begin
    evaluator_by_session.evaluate(ByteArrayInputStream.new(code))
  rescue
    'Error: ' + $!
  end

  (@result.is_a?(ArrayList) && @result.size == 1) ? @result[0].to_s : @result.to_s
end

def children(graph, out_edges, in_edges, depth = 0)
  return [] if depth == 6 
  
  children = []
  in_edges.uniq.each do |id|
    command = "g:json(#{graph}/E[@id = \"#{id}\"]/outV)".to_java_bytes
    vertex = JSON(evaluate_code(command))
    children << children_hash(vertex, graph, depth)
  end

  out_edges.uniq.each do |id|
    command = "g:json(#{graph}/E[@id = \"#{id}\"]/inV)".to_java_bytes
    vertex = JSON(evaluate_code(command))
    children << children_hash(vertex, graph, depth)
  end 

  children
end

def children_hash(vertex, graph, depth)
  {
    :id => vertex['_id'],
    :data => vertex['properties'],
    :children => children(graph, vertex['outE'], vertex['inE'], depth + 1)
  }
end
