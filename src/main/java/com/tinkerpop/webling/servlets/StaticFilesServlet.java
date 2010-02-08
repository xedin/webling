package com.tinkerpop.webling.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
	
/**
 * @author Pavel A. Yaskevich
 */
public class StaticFilesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String target 	= request.getPathInfo();
        String filepath = (target == "/") ? "./public/index.html" : "./public" + target;
      
        ServletContext sc = getServletContext();
        String mimeType = sc.getMimeType(filepath);
 
        if (mimeType == null) {
            sc.log("[GET " + target + "] 500 - Could not get MIME type");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }
        
        // set content type
        response.setContentType(mimeType);
        response.setStatus(HttpServletResponse.SC_OK); 
        sc.log("[GET " + target + "] 200 OK");

        // set content size
        File file = new File(filepath);
        int fileLength = (int)file.length();
        response.setContentLength(fileLength);
     
        // open the file and output streams
        FileInputStream in = new FileInputStream(file);
        OutputStream out = response.getOutputStream();
     
        // copy the contents of the file to the output stream
        byte[] buf = new byte[fileLength];
        int count = 0;
        
        while ((count = in.read(buf)) != 0) {
            out.write(buf, 0, count);
        }
         
        in.close();
        out.close();
    }
}
