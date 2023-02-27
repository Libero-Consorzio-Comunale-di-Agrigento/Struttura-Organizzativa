//SPCommandFactory class @0-FEB7FD30
package com.codecharge.db;

import java.util.*;
import com.codecharge.util.*;
import com.codecharge.db.*;
import com.codecharge.*;

public class SPCommandFactory {
    public static SPCommand getSPCommand( String connectionName ) {
        SPCommand spCommand = null;
        Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute( Names.SITE_PROPERTIES_KEY );
        if ( siteProps == null ) {
            spCommand = new SPCommand();
        } else {
            String dbType = siteProps.getProperty( connectionName + ".dbType" );
            if ( "oracle".equalsIgnoreCase( dbType ) ) { 
                spCommand = new OracleSPCommand();
            } else {
                spCommand = new SPCommand();
            }
        }
        return spCommand;
    }
}
//End SPCommandFactory class

