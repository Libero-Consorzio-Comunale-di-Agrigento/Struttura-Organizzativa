//DefaultControllerHandler class @0-795C027A
package com.codecharge.util;

import com.codecharge.events.*;
import com.codecharge.Names;
import java.util.*;

public class DefaultControllerHandler implements ControllerListener {

    public void appInitializing( AppEvent e ) {
        ContextStorage.setContextStorageClassName( "com.codecharge.util.SimpleContextStorage" );
        ((SimpleContextStorage) ContextStorage.getInstance()).setServletContext( e.getServletConfig().getServletContext() );
    }

    public void appDestroyed( AppEvent e ) {}

    public void controllerInitializing( ControllerEvent e ) {
        SessionStorage.setSessionStorageClassName( "com.codecharge.util.SimpleSessionStorage" );
        ((SimpleSessionStorage) SessionStorage.getInstance( e.getHttpServletRequest() )).setResponse( e.getHttpServletResponse() );

        if (!(SessionStorage.getInstance(e.getHttpServletRequest()).getAttribute(Names.CCS_LOCALE_KEY) instanceof CCSLocale)) {
          String defaultDateFormat = (String) ContextStorage.getInstance().getAttribute( "defaultDateFormat" );
          String defaultBooleanFormat = (String) ContextStorage.getInstance().getAttribute( "defaultBooleanFormat" );
          String encoding = (String) ContextStorage.getInstance().getAttribute( "encoding" );

          // set currentLocale
          String language = (String) ContextStorage.getInstance().getAttribute( "language" );
          Locale locale = null;
          if ( StringUtils.isEmpty( language ) ) {
            locale = Locale.getDefault();
          } else {
            HashMap langs = (HashMap) ContextStorage.getInstance().getAttribute(Names.LANGUAGES_KEY);
            if (langs != null) {
                locale = (Locale) langs.get(language);
            }
          }
          if ( locale == null ) {
            locale = Locale.getDefault();
          }

          CCSLocale ccsLocale = new CCSLocale(locale, encoding);
          if ( ! StringUtils.isEmpty(defaultDateFormat) ) {
            ccsLocale.setDateFormatPattern(defaultDateFormat);
          }
          if ( ! StringUtils.isEmpty(defaultBooleanFormat) ) {
            ccsLocale.setBooleanFormatPattern(defaultBooleanFormat);
          }

          SessionStorage.getInstance(e.getHttpServletRequest()).setAttribute(Names.CCS_LOCALE_KEY, ccsLocale);
        }        
    }

}

//End DefaultControllerHandler class

