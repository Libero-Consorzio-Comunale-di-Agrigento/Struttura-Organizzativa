//InitServlet head @0-BEC82766
package com.codecharge;

import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
import com.codecharge.events.*;
import java.io.*;
import java.util.*;
import java.text.Format;
import javax.servlet.*;
import javax.servlet.http.*;

public class InitServlet extends HttpServlet {

    ServletConfig config;

  public void init(ServletConfig conf) throws ServletException {
    super.init(conf);
    this.config = conf;
    ServletContext ctx = getServletContext();
    Properties siteProps = new Properties();
    Properties languages = new Properties();
    HashMap langs = new HashMap();


//End InitServlet head

//InitServlet: init context storage @0-E9B4AD2F
      AppEvent appEvent = new AppEvent( this.config );
      String handlerClassName = this.config.getInitParameter( "controllerHandlerClassName" );
      if ( ! StringUtils.isEmpty( handlerClassName ) ) {
        handlerClassName = "com.codecharge.util.DefaultControllerHandler";
      }
      try {
          Class handler = Class.forName( handlerClassName );
          ControllerListener cl = (ControllerListener) handler.newInstance();
          cl.appInitializing( appEvent );
      } catch ( java.lang.ClassNotFoundException cnfe ) {
          System.err.println( "InitServlet: Class '" + handlerClassName + "' is not found" );
          ContextStorage.setContextStorageClassName( "com.codecharge.util.SimpleContextStorage" );
          ((SimpleContextStorage) ContextStorage.getInstance()).setServletContext( ctx );
      } catch ( java.lang.InstantiationException ie ) {
          System.err.println( "InitServlet: Unable to create instance '" + handlerClassName );
          ContextStorage.setContextStorageClassName( "com.codecharge.util.SimpleContextStorage" );
          ((SimpleContextStorage) ContextStorage.getInstance()).setServletContext( ctx );
      } catch ( java.lang.IllegalAccessException iae ) {
          System.err.println( "InitServlet: IllegalAccessException occurred while creating instance '" + handlerClassName  );
          ContextStorage.setContextStorageClassName( "com.codecharge.util.SimpleContextStorage" );
          ((SimpleContextStorage) ContextStorage.getInstance()).setServletContext( ctx );
      }

//End InitServlet: init context storage

//InitServlet: init @0-75FC4B1C

    final String connPrefix = "Connection.";
    final int connPrefixLength = connPrefix.length();

    Enumeration initParameterNames = conf.getInitParameterNames();
    Hashtable drivers = new Hashtable();

    while ( initParameterNames.hasMoreElements() ) {
        String initParameterName = (String) initParameterNames.nextElement();
        if ( initParameterName.startsWith( connPrefix ) ) {
            String connectionName = initParameterName.length() > connPrefixLength ? initParameterName.substring( connPrefixLength ) : "";
            if ( ! StringUtils.isEmpty( connectionName ) ) {
                String connectionProperties = conf.getInitParameter( initParameterName );
                connectionProperties = StringUtils.replace( connectionProperties, "\r", "" );
                StringBuffer sb = new StringBuffer();
                StringTokenizer st = new StringTokenizer( connectionProperties, "\n" );
                while ( st.hasMoreTokens() ) {
                    String token = st.nextToken().trim();
                    sb.append( connectionName + "." + token + "\n" );
                    if ( token.startsWith( "driver=" ) ) {
                        String driver = token.substring( 7 );
                        drivers.put( driver, driver );
                    }
                }
                try {
                    siteProps.load( new ByteArrayInputStream( sb.toString().getBytes() ) );
                } catch ( Exception e ) {
                    System.err.println( "Unable to open config file." );
                }
            }
        } else {
            siteProps.setProperty( initParameterName, conf.getInitParameter( initParameterName ) );
        }
    }

    String configFilePath = conf.getInitParameter("configuration.file");
    if( configFilePath != null ) {

        // Load properties of site
        InputStream cf = null;
        if ( "true".equalsIgnoreCase( (String) conf.getInitParameter("usedUnpackedWarFile") ) ) {
            try {
                cf = new java.io.FileInputStream( getServletContext().getRealPath( configFilePath ) );
            } catch ( FileNotFoundException fnfe ) {
                System.out.println( "Config file is not found." );
            }
        } else {
            cf = ctx.getResourceAsStream( configFilePath );
        }

        if( cf == null) {
          System.out.println( "Unable to open config file." );
        }
        else {
          try {
            siteProps.load( cf );
            cf.close();
          }
          catch (Exception e) {
              System.out.println("Unable to read properties file.");
          }
        }

        Enumeration siteParams = siteProps.propertyNames();
        while ( siteParams.hasMoreElements() ) {
            String name = (String) siteParams.nextElement();
            String connName = null;
            if ( name.endsWith( ".name" ) ) {
                connName = siteProps.getProperty( name );
            }
            if ( connName != null ) {
                String driverName = siteProps.getProperty( connName + ".driver" );
                drivers.put( driverName, driverName );
            }
        }

    }


    // Forming of list of JDBC-drivers which will registered
    StringBuffer drvSb = new StringBuffer();
    Enumeration drvs = drivers.keys();
    while ( drvs.hasMoreElements() ) {
        drvSb.append( ((String) drvs.nextElement()) + ";" );
    }
    siteProps.setProperty( "drivers", drvSb.toString() );

    String logFile = siteProps.getProperty("logfile");
    CCLogger logger = CCLogger.getInstance();
    if ("out".equals(logFile)) {
        logger.setLogFile(CCLogger.STDOUT);
    } else if ("err".equals(logFile)) {
        logger.setLogFile(CCLogger.STDERR);
    } else if ("none".equals(logFile)) {
        logger.setLogFile(CCLogger.NONE);
    } else {
        logger.setLogFile(logFile);
    }
    String logPriority = siteProps.getProperty("logpriority");
    if ("debug".equals(logPriority)) {
        logger.setPriority(CCLogger.DEBUG);
    } else if ("info".equals(logPriority)) {
        logger.setPriority(CCLogger.INFO);
    } else if ("warn".equals(logPriority)) {
        logger.setPriority(CCLogger.WARN);
    } else if ("error".equals(logPriority)) {
        logger.setPriority(CCLogger.ERROR);
    } else {
        logger.setPriority(CCLogger.FATAL);
    }

    String languagesFilePath = conf.getInitParameter("languages.file");
    if( languagesFilePath != null ) {

        // Load properties of site
        InputStream cf = null;
        if ( "true".equalsIgnoreCase( (String) conf.getInitParameter("usedUnpackedWarFile") ) ) {
            try {
                cf = new java.io.FileInputStream( getServletContext().getRealPath( languagesFilePath ) );
            } catch ( FileNotFoundException fnfe ) {
                System.out.println( "Config file is not found." );
            }
        } else {
            cf = ctx.getResourceAsStream( languagesFilePath );
        }

        if( cf == null) {
          System.out.println( "Unable to open config file." );
        }
        else {
          try {
            languages.load( cf );
            cf.close();
          }
          catch (Exception e) {
              System.out.println("Unable to read properties file.");
          }
        }

        Enumeration langParams = languages.propertyNames();
        while ( langParams.hasMoreElements() ) {
            String name = (String) langParams.nextElement();
            if ( name.endsWith( ".language" ) ) {
                String localeKey = name.substring(0, name.indexOf('.'));
                String localeLang = languages.getProperty( name );
                if ( StringUtils.isEmpty(localeLang) ) continue;
                String localeCountry = languages.getProperty( localeKey + ".country" );
                if ( localeCountry == null ) localeCountry = "";
                String localeVariant = languages.getProperty( localeKey + ".variant" );
                if ( localeVariant == null ) localeVariant = "";
                langs.put(localeKey, new Locale(localeLang, localeCountry, localeVariant));
            }
        }
    }


    addToContextStorage(Names.CONTEXT_KEY, ctx);
    addToContextStorage(Names.LANGUAGES_KEY, langs);
    addToContextStorage(Names.SITE_PROPERTIES_KEY, siteProps);
    addToContextStorage("controllerHandlerClassName", handlerClassName );
    addToContextStorage("serverUrl", (String) siteProps.getProperty("serverUrl") );
    addToContextStorage("securedUrl", (String) siteProps.getProperty("securedUrl") );
    addToContextStorage("encoding", (String) siteProps.getProperty("encoding") );
    addToContextStorage("language", (String) siteProps.getProperty("language") );
    addToContextStorage("defaultDateFormat", (String) siteProps.getProperty("defaultDateFormat") );
    addToContextStorage("defaultBooleanFormat", (String) siteProps.getProperty("defaultBooleanFormat") );

    if ( StringUtils.isEmpty((String) siteProps.getProperty("authenticator.securityType") ) ) {
        addToContextStorage("authenticator.securityType", "CCS" );
    } else {
        addToContextStorage("authenticator.securityType", (String) siteProps.getProperty("authenticator.securityType") );
    }

    addToContextStorage("authenticator.WWW-Authenticate", (String) siteProps.getProperty("authenticator.WWW-Authenticate") );
    addToContextStorage("loginStorage", (String) siteProps.getProperty("loginStorage") );
    addToContextStorage("userIdVar", (String) siteProps.getProperty("userIdVar") );
    addToContextStorage("groupIdVar", (String) siteProps.getProperty("groupIdVar") );
    addToContextStorage("loginVar", (String) siteProps.getProperty("loginVar") );
    addToContextStorage("levelInclusionBoolean",
            new Boolean( (String) siteProps.getProperty("levelInclusion") ) );

    if ( "true".equalsIgnoreCase( (String) siteProps.getProperty("usedUnpackedWarFile") ) ) {
      addToContextStorage("usedUnpackedWarFile", (String) siteProps.getProperty("usedUnpackedWarFile") );
    }

    if ( "true".equalsIgnoreCase( (String) siteProps.getProperty("convertReturnLinkToAbsolute") ) ) {
      addToContextStorage("convertReturnLinkToAbsolute", (String) siteProps.getProperty("convertReturnLinkToAbsolute") );
    }

    Format dateFormat;
    Format booleanFormat;

    Enumeration propNames = siteProps.propertyNames();
    while (propNames.hasMoreElements()) {
        dateFormat = null;
        booleanFormat = null;
        String name = (String) propNames.nextElement();
        if (name.endsWith(".url")) {
            String poolName = name.substring(0, name.lastIndexOf("."));
            String dateFormatPattern = siteProps.getProperty(poolName + ".dateFormat");
            if ( ! StringUtils.isEmpty(dateFormatPattern) ) {
                if ( "GeneralDate".equalsIgnoreCase( dateFormatPattern ) ) {
                    dateFormat = java.text.DateFormat.getDateTimeInstance();
                } else if ( "LongDate".equalsIgnoreCase( dateFormatPattern ) ) {
                    dateFormat = java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG);
                } else if ( "ShortDate".equalsIgnoreCase( dateFormatPattern ) ) {
                    dateFormat = java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT);
                } else if ( "LongTime".equalsIgnoreCase( dateFormatPattern ) ) {
                    dateFormat = java.text.DateFormat.getTimeInstance(java.text.DateFormat.LONG);
                } else if ( "ShortTime".equalsIgnoreCase( dateFormatPattern ) ) {
                    dateFormat = java.text.DateFormat.getTimeInstance(java.text.DateFormat.SHORT);
                } else {
                    dateFormat = new java.text.SimpleDateFormat( dateFormatPattern );
                }
            }
            String booleanFormatPattern = siteProps.getProperty(poolName + ".booleanFormat");
            if ( ! StringUtils.isEmpty(booleanFormatPattern) ) {
              int pos = booleanFormatPattern.indexOf( ";" );
              int pos1 = booleanFormatPattern.indexOf( ";" , pos+1 );
              if ( pos > -1 ) {
                String trueValue = booleanFormatPattern.substring ( 0, pos );
                String falseValue = null;
                String defaultValue = null;
                if ( pos1 == -1 ) {
                    falseValue = booleanFormatPattern.substring ( pos+1 );
                } else {
                    falseValue = booleanFormatPattern.substring ( pos+1, pos1 );
                    defaultValue = booleanFormatPattern.substring ( pos1+1 );
                }
                booleanFormat = new BooleanFormat( trueValue, falseValue, defaultValue );
              }
            }
            if ( dateFormat != null ) getServletContext().setAttribute( poolName + "DateFormat", dateFormat );
            if ( booleanFormat != null ) getServletContext().setAttribute( poolName + "BooleanFormat", booleanFormat );
        }
    }

    boolean useDs = true;
    DBConnectionManager connMgr;


  }

//End InitServlet: init

//InitServlet: destroy @0-D463E08D
  public void destroy() {

    getServletContext().removeAttribute(Names.SITE_PROPERTIES_KEY);

    CCLogger logger = CCLogger.getInstance();
    AppEvent appEvent = new AppEvent( this.config );
    String handlerClassName = this.config.getInitParameter( "controllerHandlerClassName" );
    if ( ! StringUtils.isEmpty( handlerClassName ) ) {
      handlerClassName = "com.codecharge.util.DefaultControllerHandler";
    }
    try {
        Class handler = Class.forName( handlerClassName );
        ControllerListener cl = (ControllerListener) handler.newInstance();
        cl.appDestroyed( appEvent );
    } catch ( java.lang.ClassNotFoundException cnfe ) {
        logger.error( "InitServlet: Class '" + handlerClassName + "' is not found" );
    } catch ( java.lang.InstantiationException ie ) {
        logger.error( "InitServlet: Unable to create instance '" + handlerClassName );
    } catch ( java.lang.IllegalAccessException iae ) {
        logger.error( "InitServlet: IllegalAccessException occurred while creating instance '" + handlerClassName  );
    }

    super.destroy();
  }

  private static void addToContextStorage(String key, Object value) {
  	if ( StringUtils.isEmpty(key) || value == null ) return;
	ContextStorage.getInstance().setAttribute(key, value);
  }
}
//End InitServlet: destroy

