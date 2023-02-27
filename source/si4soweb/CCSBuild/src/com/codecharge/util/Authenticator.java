//Authenticator class @0-E27E744B
package com.codecharge.util;

import java.security.Principal;
import java.util.Vector;
import javax.servlet.http.*;

public class Authenticator implements HttpSessionBindingListener {

    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected Vector listeners = new Vector();

    protected Principal principal;

    public static Authenticator getInstance( HttpServletRequest request ) {
        return null;
    }

    public Principal getUserPrincipal() {
        return principal;
    }
    
    public boolean authenticate( String userLogin, String userPassword ) {
        return false;
    }

    public boolean isUserInRole(String groupName) {
        return false;
    }

    public void invalidate() {
        principal = null;
    } 
        
    public String getRemoteUser() {
        String remoteUser = null;
        Principal principal = getUserPrincipal();
        if ( principal != null ) {
            remoteUser = principal.getName();
        }
        return remoteUser;
    }
    
    public String getUserId() {
        return null;
    }
    
    public String getUserName() {
        return getRemoteUser();
    }

    public String getGroupId() {
        return null;
    }

    public void setRequest( HttpServletRequest request ) {
        this.request = request;
    }

    public void setResponse( HttpServletResponse response ) {
        this.response = response;
    }
    
    /** Add Event handler. */
    public synchronized void addHttpSessionBindingListener(HttpSessionBindingListener listener) {
        listeners.addElement(listener);
    }

    /** Remove Event handler. */
    public synchronized void removeHttpSessionBindingListener(HttpSessionBindingListener listener) {
        listeners.removeElement(listener);
    }

    public void valueBound(HttpSessionBindingEvent event) {
        Vector l;
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((HttpSessionBindingListener)l.elementAt(i)).valueBound(event);
        }
    }
    
    public void valueUnbound(HttpSessionBindingEvent event) {
        Vector l;
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((HttpSessionBindingListener)l.elementAt(i)).valueUnbound(event);
        }
    }
}

//End Authenticator class

