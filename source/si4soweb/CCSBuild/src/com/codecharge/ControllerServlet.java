//ConrtollerServlet class @0-34DA98F5
package com.codecharge;

import com.codecharge.util.*;
import com.codecharge.events.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.util.*;
import java.io.*;

public class ControllerServlet extends HttpServlet {
  protected static CCLogger logger;
  protected static ServletContext context;

  public void init( ServletConfig conf ) throws ServletException {
    super.init(conf);
    ControllerServlet.logger = CCLogger.getInstance();
    ControllerServlet.context = conf.getServletContext();
  }
  
  protected void service(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {

    logger.info("-= ControllerServlet : " + request.getServletPath() + " =-"); 
//End ConrtollerServlet class

//ControllerServlet: init session storage @0-264B1BB1
    ControllerEvent controllerEvent = new ControllerEvent( ControllerServlet.context, request, response );
    String handlerClassName = ContextStorage.getInstance().getAttributeAsString( "controllerHandlerClassName" );
    if ( ! StringUtils.isEmpty( handlerClassName ) ) {
      handlerClassName = "com.codecharge.util.DefaultControllerHandler";
    }
    try {
        Class handler = Class.forName( handlerClassName );
        ControllerListener cl = (ControllerListener) handler.newInstance();
        cl.controllerInitializing( controllerEvent );
    } catch ( java.lang.ClassNotFoundException cnfe ) {
        logger.error( "Class '" + handlerClassName + "' is not found" );
        SessionStorage.setSessionStorageClassName( "com.codecharge.util.SimpleSessionStorage" );
        ((SimpleSessionStorage) SessionStorage.getInstance( request )).setResponse( response );
    } catch ( java.lang.InstantiationException ie ) {
        logger.error( "Unable to create instance '" + handlerClassName );
        SessionStorage.setSessionStorageClassName( "com.codecharge.util.SimpleSessionStorage" );
        ((SimpleSessionStorage) SessionStorage.getInstance( request )).setResponse( response );
    } catch ( java.lang.IllegalAccessException iae ) {
        logger.error( "IllegalAccessException occurred while creating instance '" + handlerClassName  );
        SessionStorage.setSessionStorageClassName( "com.codecharge.util.SimpleSessionStorage" );
        ((SimpleSessionStorage) SessionStorage.getInstance( request )).setResponse( response );
    }

//End ControllerServlet: init session storage

//ControllerServlet: service @0-0B31D280
    Authenticator auth = AuthenticatorFactory.getAuthenticator( request );
    auth.setResponse( response );

    String pname = request.getServletPath();
    pname = pname.substring( 1, pname.length() - Names.ACTION_SUFFIX.length() );
    String packName = pname;
    int pos = pname.lastIndexOf("/");
    if ( pos > -1 ) {
      packName = pname.replace('.','_').replace('/','.').replace(' ','_');
      pname = pname.substring( pos+1 );
    }

    String actionClassName = packName + "." + pname + "Action";
    try {
      Class c = Class.forName(actionClassName);
      Action o = (Action)c.newInstance();
      String redir = o.perform(request, response, getServletContext());
      logger.info("ControllerServlet::perform("+actionClassName+") : redirect to "+redir);
      passControl( redir, pname, request, response);
    } catch (ClassNotFoundException cnfe) {
      logger.error( actionClassName+" class is not found"); 
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    } catch (InstantiationException inste) {
      logger.error("Unable to create "+actionClassName+" class objects"); 
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    } catch (IllegalAccessException iae) {
      logger.error("Unable to call perform method, access violation"); 
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  /**
    Pass control (redirect or forward)
    @param redirect redirect String
  **/
  final static protected void passControl(String redirect, String pageName, HttpServletRequest request, HttpServletResponse response) {
    String rd_str;
    if (redirect == null) {
      rd_str = pageName + Names.SHOW_SUFFIX;
      RequestDispatcher rd = request.getRequestDispatcher(rd_str);
      try {
        logger.info("Forward to " + rd_str + "!"); 
        rd.forward(request, response);
      } catch (ServletException srvlte) {
        logger.error("Unable to forward: " + srvlte, srvlte); 
        //srvlte.printStackTrace(System.err);
      } catch (IOException ioe) {
        logger.error("Unable to forward: " + ioe); 
      }
    } else if ("HttpServletResponse.SC_UNAUTHORIZED".equals(redirect)) {
        try {
          logger.info("UNAUTHORIZED"); 
          response.setContentType("text/html");
          response.addHeader( "Pragma", "No-cache" );
          response.addHeader( "Connection", "close" );
          response.addHeader( "Cache-Control", "no-cache" );
          response.addHeader( "WWW-Authenticate", ContextStorage.getInstance().getAttributeAsString( "authenticator.WWW-Authenticate" ) );
          response.sendError( HttpServletResponse.SC_UNAUTHORIZED );
        }
        catch (IOException ioe) {
          logger.error("IO Error: ", ioe); 
        }
    } else {
      try {
        logger.info("Redirect to "+redirect); 
        response.sendRedirect( SessionStorage.getInstance( request ).encodeRedirectURL(redirect) );
      }
      catch (IOException ioe) {
        logger.error("Unable redirect: " + ioe); 
      }
    }
  }
}
//End ControllerServlet: service

