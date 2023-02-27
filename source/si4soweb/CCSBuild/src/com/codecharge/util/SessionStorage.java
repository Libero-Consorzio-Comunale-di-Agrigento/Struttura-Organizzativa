//SessionStorage class @0-CAB2C789
package com.codecharge.util;

import javax.servlet.http.*;

public class SessionStorage {
    
    private final static String SESSION_STORAGE = "SessionStorage";
    private static String implementationClassName = "com.codecharge.util.SimpleSessionStorage";
    
    public static SessionStorageInterface getInstance( HttpServletRequest req ) {
        SessionStorageInterface storage = null;
        HttpSession _session = req.getSession();
        storage = (SessionStorageInterface) _session.getAttribute( SessionStorage.SESSION_STORAGE );
        if ( storage == null ) {
            try {
                Class c = Class.forName( implementationClassName );
                storage = (SessionStorageInterface) c.newInstance();
                _session.setAttribute( SessionStorage.SESSION_STORAGE, storage );
            } catch ( ClassNotFoundException cnfe ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", cnfe );
            } catch ( InstantiationException ie ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", ie );
            } catch ( IllegalAccessException iae ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", iae );
            }
        }
        storage.setRequest( req );
        return storage;
    }

    public static void setSessionStorageClassName ( String className ) {
        implementationClassName = className;
    }
    
}

//End SessionStorage class

