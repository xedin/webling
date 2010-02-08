package com.tinkerpop.webling.servlets;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tinkerpop.gremlin.GremlinEvaluator;
import com.tinkerpop.webling.WeblingLauncher;
	
/**
 * @author Pavel A. Yaskevich
 */
public class VisualizationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext sc = getServletContext();
        String sessionId = request.getSession(true).getId();
        String code	= "g:vis(" + request.getParameter("v") + ")";
      
        GremlinEvaluator gremlin = WeblingLauncher.getEvaluatorBySessionId(sessionId);
          
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        sc.log("[GET /visualize?v=" + request.getParameter("v") + "] 200 OK");

        try {
            List result = gremlin.evaluate(new ByteArrayInputStream(code.getBytes()));
            response.getWriter().println(((result.size() == 1) ? result.get(0) : result));
        } catch(Exception e) {
            response.getWriter().println(e.getMessage());
        }
    }
}
