//ContextStorage class @0-6A3E83A5
package com.codecharge.util;

import javax.servlet.*;
import com.codecharge.Names;

public class ContextStorage {

    private final static String CONTEXT_STORAGE = "ContextStorage";
    private static Storage storage = null;
    private static ServletContext context = null;
    private static String implementationClassName = "com.codecharge.util.SimpleContextStorage";
    
    public static Storage getInstance() {
        if ( storage == null ) {
            try {
                Class c = Class.forName( implementationClassName );
                storage = (Storage) c.newInstance();
            } catch ( ClassNotFoundException cnfe ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", cnfe );
            } catch ( InstantiationException ie ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", ie );
            } catch ( IllegalAccessException iae ) {
                CCLogger.getInstance().log("ContextStorage.getInstance(): ", iae );
            }
        }
        return storage;
    }
    public static ServletContext getContext() {
        return (ServletContext)getInstance().getAttribute(Names.CONTEXT_KEY);
    }
               
    public static void setServletContext( ServletContext context ) {
        ContextStorage.context = context;
    }

    public static void setContextStorageClassName ( String className ) {
        implementationClassName = className;
    }
    
}

//End ContextStorage class

