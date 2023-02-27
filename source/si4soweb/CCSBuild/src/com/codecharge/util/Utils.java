//Utils class @0-CE7B2212
package com.codecharge.util;

import java.io.File;
import java.util.Date;
import java.text.DateFormat;

import com.codecharge.components.*;
import com.codecharge.util.*;

public class Utils {

    public static Long convertToLong( long value ) {
        return new Long(value);
    }

    public static Long convertToLong( double value ) {
        return new Long((long) value);
    }

    public static Long convertToLong( Object value ) {
        Long result = null;
        if ( value == null || value instanceof Long ) {
            result = (Long) value;
        } else {
            if ( value instanceof Number ) {
                result = new Long( ((Number) value).longValue() );
            } else if ( value instanceof String ) {
                if ( "".equals( value ) ) {
                    result = null;
                } else {
                    result = new Long( (String) value );
                }    
            }
        }
        return result;
    }

    public static Double convertToDouble( long value ) {
        return new Double(value);
    }

    public static Double convertToDouble( double value ) {
        return new Double(value);
    }

    public static Double convertToDouble( Object value ) {
        Double result = null;
        if ( value == null || value instanceof Double ) {
            result = (Double) value;
        } else {
            if ( value instanceof Number ) {
                result = new Double(((Number) value).doubleValue());
            } else if ( value instanceof String ) {
                if ( "".equals( value ) ) {
                    result = null;
                } else {
                    result = new Double( (String) value );
                }    
            }
        }
        return result;
    }

    public static Date convertToDate( long value ) {
        return new Date(value);
    }

    public static Date convertToDate( double value ) {
        return new Date((long) value);
    }

    public static Date convertToDate( Object value ) throws java.text.ParseException {
        Date result = null;
        if ( value == null || value instanceof Date ) {
            result = (Date) value;
        } else {
            if ( value instanceof Number ) {
                result = new Date(((Number) value).longValue());
            } else if ( value instanceof String ) {
                if ( "".equals( value ) ) {
                    result = null;
                } else {
                    result = (Date) DateFormat.getDateTimeInstance().parse( (String) value );
                }    
            }
        }
        return result;
    }

    public static String convertToString( long value ) {
        return String.valueOf(value);
    }

    public static String convertToString( double value ) {
        return String.valueOf(value);
    }

    public static String convertToString( Object value ) {
        String result = null;
        if ( value == null || value instanceof String ) {
            result = (String) value;
        } else {
            result = value.toString();
        }
        return result;
    }

    public static Boolean convertToBoolean( boolean value ) {
        return new Boolean(value);
    }

    public static Boolean convertToBoolean( Object value ) {
        Boolean result = null;
        if ( value == null || value instanceof Boolean ) {
            result = (Boolean) value;
        } else if (value instanceof String) {
            result = new Boolean((String) value);
        }
        return result;
    }

    public static void printMessage(String message, javax.servlet.http.HttpServletResponse response) {
        try {
            java.io.PrintWriter actionPw = new java.io.PrintWriter( 
                    new java.io.OutputStreamWriter( response.getOutputStream() ));
            actionPw.println(message);
            actionPw.flush();
        } catch (java.io.IOException ioe) {
            ioe.printStackTrace(System.err);
        }
    }

    public static void printFatalError(String message, javax.servlet.http.HttpServletResponse response) {
        try {
            java.io.PrintWriter actionPw = new java.io.PrintWriter( 
                    new java.io.OutputStreamWriter( response.getOutputStream() ));
            actionPw.println(message);
            actionPw.flush();
            actionPw.close();
        } catch (java.io.IOException ioe) {
            ioe.printStackTrace(System.err);
        }
    }

    public static String getUserId(Page page) {
        String userId = null;
        Authenticator auth = page.getAuthenticator();
        if (auth != null) {
            userId = auth.getUserId();
        }
        return userId;
    }

    public static String getUserLogin(Page page) {
        String userName = null;
        Authenticator auth = page.getAuthenticator();
        if (auth != null) {
            userName = auth.getUserName();
        }
        return userName;
    }

    public static String getUserGroup(Page page) {
        String groupId = null;
        Authenticator auth = page.getAuthenticator();
        if (auth != null) {
            groupId = auth.getGroupId();
        }
        return groupId;
    }
    
    public static void clearFolder(String path, long maxAge) {
        if (StringUtils.isEmpty(path)) return;
        AgeFileFilter aff = new AgeFileFilter(Math.abs(maxAge));
        File current = new File(path);
        if (current.isDirectory() && current.canWrite()) {
            File[] flist = current.listFiles(aff);
            for (int i = 0; i < flist.length; i++ ) {
                if ( ! flist[i].delete() ) {
                    CCLogger.getInstance().debug("Unable to delete file "+flist[i].getName());
                }
            }
        }
    }


//End Utils class

//function controllerInitializing @0-A108F10E
	public static void controllerInitializing(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) {
		CCLogger logger = CCLogger.getInstance();
		com.codecharge.events.ControllerEvent controllerEvent = 
				new com.codecharge.events.ControllerEvent( ContextStorage.getContext(), request, response );
		String handlerClassName = ContextStorage.getInstance().getAttributeAsString( "controllerHandlerClassName" );
		if ( ! StringUtils.isEmpty( handlerClassName ) ) {
		  handlerClassName = "com.codecharge.util.DefaultControllerHandler";
		}
		try {
			Class handler = Class.forName( handlerClassName );
			com.codecharge.events.ControllerListener cl = (com.codecharge.events.ControllerListener) handler.newInstance();
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
	}

//End function controllerInitializing

//Utils class: tail @0-FCB6E20C
}

//End Utils class: tail

