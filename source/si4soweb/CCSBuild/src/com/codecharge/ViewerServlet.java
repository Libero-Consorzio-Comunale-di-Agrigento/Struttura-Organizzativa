//ViewerServlet class @0-009E2903
package com.codecharge;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import com.codecharge.util.*;

public class ViewerServlet extends HttpServlet {
  private static CCLogger logger; 

  private final static String CLASS_NOT_FOUND_MESSAGE = "Class is not found.";
  private final static String INSTANTIATION_MESSAGE = "Unable to create class object.";
  private final static String ILLEGAL_ACCESS_MESSAGE = "Unable to call 'show' method, access violation";

  public void init() {
    logger = CCLogger.getInstance();
  }

  protected void service(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {

    logger.info("-= ViewerServlet : " + request.getServletPath() + " =-");

    String pname = request.getServletPath();
    pname = pname.substring(1, pname.length() - Names.SHOW_SUFFIX.length() );
    String packName = new String(pname);
    int pos = pname.lastIndexOf("/");
    if ( pos > -1 ) {
      packName = pname.replace('.','_').replace('/','.').replace(' ','_');
      pname = pname.substring( pos+1 );
    }
    
    String body = "";
    String className = packName + "." + pname + "View";
    try {
      Class c = Class.forName(className);
      View o = (View)c.newInstance();
      body = o.show(request, response, getServletContext());
      String enc = ((CCSLocale) SessionStorage.getInstance(request).getAttribute(Names.CCS_LOCALE_KEY)).getCharacterEncoding();
      PrintWriter out = new PrintWriter( new OutputStreamWriter( response.getOutputStream(), enc ));
      out.println( body );
      out.close();
    } catch (ClassNotFoundException cnfe) {
      logger.error( ViewerServlet.CLASS_NOT_FOUND_MESSAGE ); 
    } catch (InstantiationException inste) {
      logger.error( ViewerServlet.INSTANTIATION_MESSAGE );
    } catch (IllegalAccessException iae) {
      logger.error( ViewerServlet.ILLEGAL_ACCESS_MESSAGE );
    }

    logger.info("-= ViewerServlet : " + request.getServletPath() + " finished =-");
  }

}

//End ViewerServlet class

