//Page component @0-63AD3860
package com.codecharge.components;

import java.util.Vector;
import java.util.Locale;
import java.util.HashMap;
import java.util.Iterator;
import com.codecharge.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.events.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;

public class Page extends Component {

    private String query;
    private String pagePath;
    private QueryString httpGetParams;
    private PostParams httpPostParams;
    private RequestParser requestParser;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private String redirect;
    private CCSLocale locale;
    private String currentPath;
    private HashMap blocks = new HashMap();
    private HashMap variables = new HashMap();
    private Template template;
    private HashMap cookies = new HashMap();
    private Vector outCookies = new Vector();

    private final static int MAX_DEPTH = 100;
    private StringBuffer tempPath = new StringBuffer();
    private String path[] = new String[Page.MAX_DEPTH];
    private int depth = 0;

    public Page ( String name ) {
        this( name, null,null, null );
    }

    public Page ( String name, CCSLocale locale ) {
        this( name, null, null, locale );
    }

    public Page ( String name, QueryString qs, PostParams pp, CCSLocale locale ) {
        super(name);
        httpGetParams = qs;
        httpPostParams = pp;
        setCurrentBlock("main");
        if ( locale == null ) {
            locale = new CCSLocale(); 
        }
        this.locale = locale;
    }

    public RequestParser getRequestParser() {
        return requestParser;
    }

    /** Find variable by its path. If no such path exist, create new variable with this path. **/
    public Variable getVariable(String path) {
      Variable v;
      v = (Variable)variables.get(path);
      if (v == null) {
        v = new Variable(path.substring(path.lastIndexOf("@")));
        variables.put(path, v);
      }
      return v;
    }

    /** Find block by its path. If no such path exist, create new block with this path. **/
    public Block getBlock(String path) {
      Block b;
      b = (Block)blocks.get(path);
      if (b == null) {
        b = new Block(path.substring(path.lastIndexOf("/")));
        blocks.put(path, b);
      }
      return b;
    }

    /*  Never returns null.
    */
    public String getCurrentPath() {
        return (currentPath == null ? "" : currentPath);
    }

/*    public void setCurrentPath( String currentPath ) {
        this.currentPath = currentPath;
    }
*/
  public String getActionPageName() {
    if (included) {
      Page prnt = (Page) request.getAttribute(getName()+"Parent");
      if (prnt != null)	{return prnt.getActionPageName();}
      else {return getName();}
    } else {
      return getName();
    }	
  }

    public void setCurrentBlock(String blockName) {
        path[depth++] = blockName;
        tempPath.setLength( 0 );
        int i = 0;
        for ( i = 0; i < depth-1; i++ ) {
            tempPath.append(path[i]+"/");
        }
        tempPath.append(path[i]);
        currentPath = tempPath.toString();
    }

    public void gotoParentBlock() {
        depth--;
        tempPath.setLength( 0 );
        int i = 0;
        for ( i = 0; i < depth-1; i++ ) {
            tempPath.append(path[i]+"/");
        }
        tempPath.append(path[i]);
        currentPath = tempPath.toString();
    }

    /** Returns redirection URL string. 
     * @return a String containing the redirection URL.
     */
    public String getRedirectString() { return redirect; }
/** Specify URL string for redirect. This redirection is made just before 
 * On Initialize View event, so it only makes sense to set variable's value 
 * in After Initialize event or some submit processing event in page sub components. 
 */
    public void setRedirectString(String redirect) { this.redirect = redirect; }

    public String getRedirect() { return redirect; }
    public void setRedirect(String redirect) { this.redirect = redirect; }

    public void setRequest(HttpServletRequest request) {
      this.request = request;
      Object parent = request.getAttribute(getName()+"Parent");
      if (parent != null) this.request = ((Page)parent).getRequest();
      if (requestParser==null) {
          requestParser = new RequestParser(this.request);
          requestParser.parse();
      }
      query = request.getQueryString();
      Cookie[] cooks = request.getCookies();
      if (cooks!=null) {
          for ( int i = 0; i < cooks.length; i++ ) {
              cookies.put( cooks[i].getName(), cooks[i].getValue() );
          }
      }
    }

    public String getCookie(String cookieName) {
        String cookieValue = (cookieName==null ? "" :(String) cookies.get(cookieName));
        return (cookieValue==null ? "" : cookieValue);
    }
    
    /** 
     * Returns the current request associated with this page.
     * @return the HttpServletRequest associated with this page.
     */
    public HttpServletRequest getRequest() {
      return request;
    }

    public void setResponse(HttpServletResponse response) {
      this.response = response;
    }
/** 
 * Returns the current response associated with this page.
 * @return the HttpServletResponse associated with this page.
 */
    public HttpServletResponse getResponse() {
      return response;
    }
    
    public RequestParameters getHttpGetParams() {
      return requestParser.getHttpGetParameters();
    }
    public RequestParameters getHttpGetParameters() {
      return requestParser.getHttpGetParameters();
    }

/**
 * Returns the value of a request GET parameter as a String, or null if
 * parameter does not exist.
 * @param name a String specifying the name of the parameter
 * @return a String representing the single value of the parameter
 */
    public String getHttpGetParameter(String name) {
        return requestParser.getHttpGetParameters().getParameter(name);
    }

    public String getHttpGetParameter(String name, String defaultValue) {
        String val = requestParser.getHttpGetParameters().getParameter(name);
        if (val==null) {
            val = defaultValue;
        }
        return val;
    }

/** @deprecated */
    public void setHttpGetParams( QueryString qs ) {
      httpGetParams = qs;
    }

    public RequestParameters getHttpPostParams() {
        return requestParser.getHttpPostParameters();
    }

    public RequestParameters getHttpPostParameters() {
        return requestParser.getHttpPostParameters();
    }

/**
 * Returns the value of a request POST parameter as a String, or null if
 * parameter does not exist.
 * @param name a String specifying the name of the parameter
 * @return a String representing the single value of the parameter
 */
    public String getHttpPostParameter(String name) {
        return requestParser.getHttpPostParameters().getParameter(name);
    }

    public String getHttpPostParameter(String name, String defaultValue) {
        String val = requestParser.getHttpPostParameters().getParameter(name);
        if (val==null) {
            val = defaultValue;
        }
        return val;
    }

/** @deprecated */
    public void setHttpPostParams( PostParams pp ) {
      httpPostParams = pp;
    }

    public String getPagePath() {
      return pagePath;
    }

    public void setPagePath( String pp ) {
      pagePath = pp;
    }

/**
 * Returns the value of a request parameter as a String, or null if parameter
 * does not exist.
 * @param name a String specifying the name of the parameter
 * @return a String representing the single value of the parameter
 */
    public String getParameter( String name ) {
        return getParameter(name, "");
    }
    
/**
 * Returns the value of a request POST parameter as a String, or default value
 * if parameter does not exist.
 * @param name a String specifying the name of the parameter
 * @param defaultValue - a String specifying the default value of the parameter
 * @return a String representing the single value of the parameter
 */
    public String getParameter( String name, String defaultValue ) {
      String param = defaultValue;
      if ( getHttpGetParameters() == null && getHttpPostParameters() == null ) {
        return "";
      } 
      if ( getHttpGetParameters() != null ) {
        param = getHttpGetParameters().getParameter( name );
      } 
      if ( getHttpPostParameters() != null && param == null ) {
        param = getHttpPostParameters().getParameter( name );
      } 
      return param;
    }
    
/**
 * Returns a UploadedFile object that present a uploaded file, or null if
 * file does not uploaded.
 * @param name a String specifying the name of the file.
 * @return a UploadedFile object representing the single file
 */
    public UploadedFile getFile(String name) {
        return requestParser.getPostFile(name);
    }

    public Authenticator getAuthenticator() {
        if (request == null) return null;
        Authenticator auth = (Authenticator) SessionStorage.getInstance( request ).getAttribute( "ccs.Authenticator" );
        if (auth == null) {
            auth = AuthenticatorFactory.getAuthenticator( request );
        }
        return auth;
    }

    /** @deprecated */
    public void setQuery( String query ) {this.query = query;}

    /** @deprecated */
    public String getQuery() { return query; }

    /** Find Component in children collection by name.
		@param name the Component name
		@return the Component of the given name or null if no such Component
		exists
	*/
    public Component getComponent(String name) {
        return (Component) getChild(name);
    }
    
/** Find Grid in children collection by name.
    @param name the Grid name
    @return the Grid of the given name or null if no such Grid
    exists
*/
    public Grid getGrid(String name) {
        return (Grid) getChild(name);
    }
    
/** Find Record in children collection by name.
    @param name the Record name
    @return the Record of the given name or null if no such Record
    exists
*/
    public Record getRecord(String name) {
        return (Record) getChild(name);
    }
    
/** Find EditableGrid in children collection by name.
    @param name the record name
    @return the EditableGrid of the given name or null if no such EditableGrid
    exists
*/
    public EditableGrid getEditableGrid(String name) {
        return (EditableGrid) getChild(name);
    }
    
/** Find Directory in children collection by name.
    @param name the Directory name
    @return the Directory of the given name or null if no such Directory
    exists
*/
    public Directory getDirectory(String name) {
        return (Directory) getChild(name);
    }
    
/** Find Path in children collection by name.
    @param name the Path name
    @return the Path of the given name or null if no such Path
    exists
*/
    public Path getPath(String name) {
        return (Path) getChild(name);
    }
    
    public synchronized void addPageListener (PageListener l) {
        listeners.addElement(l);
    }
    public synchronized void removePageListener (PageListener l) {
        listeners.removeElement(l);
    }

    public CCSLocale getCCSLocale() {
        return this.locale;
    }

    public void setCCSLocale(CCSLocale ccsLocale) {
        if ( ccsLocale == null ) {
            ccsLocale = new CCSLocale();
        }
        this.locale = ccsLocale;
    }

    public String getCharacterEncoding() {
        return this.locale.getCharacterEncoding();
    }

    public Locale getLocale() {
        return this.locale.getLocale();
    }

    public void setCharacterEncoding( String encoding ) {
        this.locale.setCharacterEncoding(encoding);
    }

    /**
     * Returns the Template object for the direct usage of the template library or null for JSP.
     * @return the Template object or null
     */
    public Template getTemplate() { return template; }
    public void setTemplate(Template tmpl) { template = tmpl; }

    /** JSP specific. Send redirect to page stored in redirect property.
        @return whether the redirect actually happened.
     **/
    public boolean redirect() {
      if (included) {
        if (redirect != null) {
          ((Page)request.getAttribute(getName()+"Parent")).setRedirect(redirect);
          return true;
        }
      } else {
        if (redirect != null) {
          try {
            response.sendRedirect(redirect);
          } catch (java.io.IOException ioe) {
            CCLogger.getInstance().error("Unable to redirect to "+redirect);
          }
          return true;
        }
      }
      return false;
    }

    public void addCookie(Cookie c) {
      if (included) {
        ((Page)request.getAttribute(getName()+"Parent")).addCookie(c);
      } else {
        outCookies.add(c);
      }
    }
    public void setCookies() {
      //if (!included) equivalent to outCookies is empty
      for (Iterator i = outCookies.iterator(); i.hasNext(); ) {
        response.addCookie((Cookie)i.next());
      }
    }

    /** Properties added to merge two models. **/
    private boolean included;
    public void setIncluded(boolean f) {included = f;}
    public boolean isIncluded() {return included;}
    private boolean sslAccess;
    public void setOnlySslAccess(boolean f) {sslAccess = f;}
    public boolean isOnlySslAccess() {return sslAccess;}


    public void fireAfterInitializeEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PageListener)v.elementAt(i)).afterInitialize(e);
        }
    }
    
    public void fireOnInitializeViewEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PageListener)v.elementAt(i)).onInitializeView(e);
        }
    }
    
    public void fireBeforeShowEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PageListener)v.elementAt(i)).beforeShow(e);
        }
    }
    
    public void fireBeforeUnloadEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PageListener)v.elementAt(i)).beforeUnload(e);
        }
    }

}
//End Page component

