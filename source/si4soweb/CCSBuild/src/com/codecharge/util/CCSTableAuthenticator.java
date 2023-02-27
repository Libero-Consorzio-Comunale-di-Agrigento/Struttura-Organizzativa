//CCSTableAuthenticator class @0-2284A095
package com.codecharge.util;

import java.security.Principal;
import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.lang.reflect.*;

import com.codecharge.db.*;
import com.codecharge.Names;

public class CCSTableAuthenticator extends Authenticator {

    protected String connectionName;
    protected String tableName;
    protected String loginFieldName;
    protected String passwordFieldName;
    protected String groupIdFieldName;
    protected String userIdFieldName;

    protected String userIdVarName;
    protected String groupIdVarName;
    protected String userLoginVarName;

    protected String sql;

    protected boolean inheritanceRights;

    private CCSTableAuthenticator() {
    }

    public static Authenticator getInstance( HttpServletRequest request ) {
        Authenticator auth = (Authenticator) SessionStorage.getInstance( request ).getAttribute( "ccs.Authenticator" );
        if ( auth == null ) {
            auth = new CCSTableAuthenticator();
            Properties siteProps = (Properties) ContextStorage.getInstance().getAttribute( Names.SITE_PROPERTIES_KEY );
            Enumeration propNames = siteProps.propertyNames();
            String prefix = "authenticator.";
            int prefixLength = prefix.length();

            while ( propNames.hasMoreElements() ) {
                String name = (String) propNames.nextElement();
                if ( name.equalsIgnoreCase( "authenticator.classname" ) ) {
                } else if ( name.toLowerCase().startsWith( prefix ) ) {
                    String propertyName = name.substring( prefixLength );
                    String methodName = "set" + propertyName.substring( 0, 1 ).toUpperCase() + propertyName.substring( 1 );
                    try {
                        Method method = CCSTableAuthenticator.class.getMethod( methodName, new Class[] { String.class } );
                        if ( method != null ) {
                            method.invoke( (Object) auth, new Object[] { siteProps.getProperty( name ) } );
                        }
                    } catch ( NoSuchMethodException nsme ) {
                    } catch ( SecurityException se ) {
                    } catch ( InvocationTargetException ite ) {
                    } catch ( IllegalArgumentException iae ) {
                    } catch ( IllegalAccessException iae1 ) {
                    }
                }
            }
        }
        auth.setRequest( request );
        SessionStorage.getInstance( request ).setAttribute( "ccs.Authenticator", auth );
        return auth;
    }

    public void setConnectionName( String connectionName ) {
        this.connectionName = connectionName;
    }

    public void setTableName( String tableName ) {
        this.tableName = tableName;
    }

    public void setLoginFieldName( String loginFieldName ) {
        this.loginFieldName = loginFieldName;
    }

    public void setPasswordFieldName( String passwordFieldName ) {
        this.passwordFieldName = passwordFieldName;
    }

    public void setGroupIdFieldName( String groupIdFieldName ) {
        this.groupIdFieldName = groupIdFieldName;
    }

    public void setUserIdFieldName( String userIdFieldName ) {
        this.userIdFieldName = userIdFieldName;
    }

    public void setUserIdVarName( String userIdVarName ) {
        this.userIdVarName = userIdVarName;
    }

    public void setGroupIdVarName( String groupIdVarName ) {
        this.groupIdVarName = groupIdVarName;
    }

    public void setLoginVarName( String userLoginVarName ) {
        this.userLoginVarName = userLoginVarName;
    }

    public void setSql( String sql ) {
        this.sql = sql;
    }

    public void setInheritanceRights( String flag ) {
        if ( flag == null ) {
            this.inheritanceRights = false;
        } else {
            this.inheritanceRights = new Boolean( flag ).booleanValue();
        }
    }

    public void setInheritanceRights( boolean flag ) {
        this.inheritanceRights = flag;
    }

    public void setInheritanceRights( Boolean flag ) {
        if ( flag == null ) {
            this.inheritanceRights = false;
        } else {
            this.inheritanceRights = flag.booleanValue();
        }
    }

    public Principal getUserPrincipal() {
        return this.principal;
    }
    
	protected String processLogin(String userLogin) {
    	return userLogin;
    }
    
	protected String processPassword(String userPassword) {
		return userPassword;
	}
	
	protected String buildSql(String userLogin, String userPassword, String fieldLeftDelim, String fieldRightDelim, JDBCConnection conn) {
		return "SELECT " + fieldLeftDelim + userIdFieldName + fieldRightDelim + ", " + 
				fieldLeftDelim + loginFieldName + fieldRightDelim + 
				( groupIdFieldName == null ? "" : ", " + fieldLeftDelim + groupIdFieldName + fieldRightDelim ) +
				" FROM " + fieldLeftDelim + tableName + fieldRightDelim + " WHERE " + 
				fieldLeftDelim + loginFieldName + fieldRightDelim + "=" + 
				conn.toSql( processLogin(userLogin), JDBCConnection.TEXT ) + " AND " + fieldLeftDelim +
				passwordFieldName + fieldRightDelim + "=" + conn.toSql( processPassword(userPassword), JDBCConnection.TEXT );
	}
	
	protected void afterLogin(DbRow row) {
		return;
	}
    
    public boolean authenticate( String userLogin, String userPassword ) {

        boolean authenticate = false;
        boolean dbNameUppercase = new Boolean( StringUtils.getSiteProperty( this.connectionName + ".dbNameUppercase", "" )).booleanValue();
        String dbType = StringUtils.getSiteProperty( this.connectionName + ".dbType", "" );
        String fieldLeftDelim = null;
        String fieldRightDelim = null;
        if ( dbNameUppercase && ("Oracle".equals(dbType) || "Interbase".equals(dbType))) {
            fieldLeftDelim = "";
            fieldRightDelim = "";
        } else {
            fieldLeftDelim = StringUtils.getSiteProperty( this.connectionName + ".fieldLeftDelim", "" );
            fieldRightDelim = StringUtils.getSiteProperty( this.connectionName + ".fieldRightDelim", "" );
        }
        JDBCConnection conn = JDBCConnectionFactory.getJDBCConnection( this.connectionName );
        if ( this.sql == null ) {
            this.sql = buildSql(userLogin, userPassword, fieldLeftDelim, fieldRightDelim, conn);
            CCLogger.getInstance().debug("CCSTableAuthenticator: authSql: "+this.sql);
        }
        DbRow userId = conn.getOneRow( this.sql );
        conn.closeConnection();

        if ( userId != null && userId.get( userIdFieldName ) != null ) {
            authenticate = true;
            SessionStorage.getInstance( request ).setAttribute( userIdVarName, userId.get( userIdFieldName ).toString() );
            if ( userLoginVarName != null ) { 
                SessionStorage.getInstance( request ).setAttribute( userLoginVarName, userId.get( loginFieldName ).toString() );
                this.principal = new CCSPrincipal( userId.get( loginFieldName ).toString() );
            } else {
                this.principal = new CCSPrincipal( userId.get( userIdFieldName ).toString() );
            }
            if ( groupIdVarName != null ) {
                SessionStorage.getInstance( request ).setAttribute( groupIdVarName, userId.get( groupIdFieldName ).toString() );
            }
            if ( userLoginVarName != null ) { 
                SessionStorage.getInstance( request ).setAttribute( userLoginVarName, userId.get( loginFieldName ).toString() );
            }
			afterLogin(userId);
        }
        return authenticate;
    }

    public boolean isUserInRole( String groupName ) {
        boolean isUserInRole = false;

        if ( inheritanceRights ) {
            int userGroup = Integer.MIN_VALUE;
            try {
                userGroup = Integer.parseInt( getGroupId() );
            } catch ( NumberFormatException nfe_ignore ) {
                return false;
            }
            int groupId = Integer.MIN_VALUE;
            try {
                groupId = Integer.parseInt( groupName );
            } catch ( NumberFormatException nfe_ignore ) {
                return false;
            }
            if ( userGroup >= groupId ) {
                isUserInRole = true;
            }
        } else {
            if ( getGroupId().equals( groupName ) ) {
                isUserInRole = true;
            }
        }

        return isUserInRole;
    }
    
    public boolean isUserInRole( int groupId ) {
        boolean isUserInRole = false;
        int userGroupId = Integer.MIN_VALUE;
        try {
            userGroupId = Integer.parseInt( SessionStorage.getInstance( request ).getAttributeAsString( groupIdVarName ) );
        } catch ( NumberFormatException nfe_ignore ) {}

        if ( inheritanceRights ) {
            if ( userGroupId >= groupId ) {
                isUserInRole = true;
            }
        } else {
            if ( userGroupId == groupId ) {
                isUserInRole = true;
            }
        }

        return isUserInRole;
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
        if ( this.principal == null ) {
            return null;
        } else {
            return SessionStorage.getInstance( request ).getAttributeAsString( userIdVarName );
        }
    }
    
    public String getUserName() {
        return getRemoteUser();
    }

    public String getGroupId() {
        if ( this.principal == null ) {
            return null;
        } else {
            return SessionStorage.getInstance( request ).getAttributeAsString( groupIdVarName );
        }
    }

    public void invalidate() {
        this.principal = null;
        this.sql = null;
        SessionStorage.getInstance( request ).removeAttribute( userIdVarName );
        if ( groupIdVarName != null ) {
            SessionStorage.getInstance( request ).removeAttribute( groupIdVarName );
        }
        if ( userLoginVarName != null ) { 
            SessionStorage.getInstance( request ).removeAttribute( userLoginVarName );
        }
    }

}

//End CCSTableAuthenticator class

