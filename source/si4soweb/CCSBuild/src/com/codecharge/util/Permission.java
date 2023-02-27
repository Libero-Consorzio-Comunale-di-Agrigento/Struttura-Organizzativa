//Permission class @0-8B1685FF
package com.codecharge.util;

import java.util.*;
import com.codecharge.*;

public class Permission {

    final static public int ALLOW_NOTHING = 0;
    final static public int ALLOW_ACCESS = 1;
    final static public int ALLOW_READ = 1; // same as ALLOW_ACCESS
    final static public int ALLOW_INSERT = 2;
    final static public int ALLOW_UPDATE = 4;
    final static public int ALLOW_DELETE = 8;
    final static public int ALLOW_FULL = ALLOW_ACCESS + ALLOW_INSERT + ALLOW_UPDATE + ALLOW_DELETE;

    private Vector groupPermission;
    private boolean levelInclusion;
    
    private class GroupPermission {
        Object id;
        int permission;
        
        GroupPermission( int id, int permission ) {
            this.id = new Integer( id );
            this.permission = permission;
        }

        GroupPermission( String id, int permission ) {
            this.id = id;
            this.permission = permission;
        }
        
        Object getId() { return id; }
        
        int getPermission() { return permission; }
        void setPermission( int permission ) { this.permission = permission; }

        public String toString() {
            StringBuffer sb = new StringBuffer();
            sb.append("GroupId: " + id + " permission: " );
            if ( ( permission & Permission.ALLOW_READ ) > 0 ) {
                sb.append( "READ " );
            } else if ( ( permission & Permission.ALLOW_INSERT ) > 0 ) {
                sb.append( "INSERT " );
            } else if ( ( permission & Permission.ALLOW_UPDATE ) > 0 ) {
                sb.append( "UPDATE " );
            } else if ( ( permission & Permission.ALLOW_DELETE ) > 0 ) {
                sb.append( "DELETE " );
            }
            sb.append( "\n" );
            return sb.toString();
        }
    }
    
    public Permission() {
        groupPermission = new Vector( 10, 5 );
        String siteLevelInclusion = null;
        Properties siteProps = (Properties) ContextStorage.getInstance()
                .getAttribute( Names.SITE_PROPERTIES_KEY );
        if ( siteProps != null ) {
            siteLevelInclusion = (String) siteProps.get( "levelInclusion" );
        }
        levelInclusion = Boolean.valueOf( siteLevelInclusion ).booleanValue();
    }

    public boolean isUseGroup() {
      if ( groupPermission == null || groupPermission.size() == 0 ) return false;
      return true;
    }
    
    synchronized public void addGroup( int id, int permission ) {
        GroupPermission group = null;
        for ( int i = 0; i < groupPermission.size(); i++ ) {
            group = (GroupPermission) groupPermission.get(i);
            if ( ((Integer) group.getId()).intValue() == id ) {
                break;
            } else {
              group = null;
            }
        }
        if ( group == null ) {
            groupPermission.add( new GroupPermission( id, permission ) );
        } else {
            group.setPermission( permission );
        }
    }
    
    synchronized public void addGroup( String id, int permission ) {
        GroupPermission group = null;
        for ( int i = 0; i < groupPermission.size(); i++ ) {
            group = (GroupPermission) groupPermission.get(i);
            if ( group.getId().toString().equals( id ) ) {
                break;
            } else {
              group = null;
            }
        }
        if ( group == null ) {
            groupPermission.add( new GroupPermission( id, permission ) );
        } else {
            group.setPermission( permission );
        }
    }

    public String[] getGroupsIdByPermission( int permission ) {
        String[] groups = null;
        Vector vgroups = new Vector();
        synchronized (this) {
            for ( int i = 0; i < groupPermission.size(); i++ ) {
                GroupPermission group = (GroupPermission) groupPermission.get(i);
                if ( ( group.getPermission() & permission ) == permission ) {
                    vgroups.add( group.getId().toString() );
                }
            }
        }

        if ( vgroups.size() > 0 ) {
            groups = new String[vgroups.size()];
            groups = (String[]) vgroups.toArray((String[]) groups);
        }

        return groups;
    }
    
    public boolean checkPermissions( int groupId, int permission ) {
        boolean check = false;
        int allowedPermission = Permission.ALLOW_NOTHING;

        synchronized (this) {
            for ( int i = 0; i < groupPermission.size(); i++ ) {
                GroupPermission group = (GroupPermission) groupPermission.get(i);
                if ( levelInclusion && ( ((Integer) group.getId()).intValue() <= groupId ) ) {
                    allowedPermission = allowedPermission | group.getPermission();
                } else if ( (! levelInclusion) && ( ((String) group.getId()).equals( String.valueOf( groupId )) ) ) {
                    allowedPermission = group.getPermission();
                    break;
                }
            }
        }
        if ( (allowedPermission & permission) == permission ) {
          check = true;
        }
        return check;
    }

    public boolean checkPermissions( String groupId, int permission ) {
        boolean check = false;
        int allowedPermission = Permission.ALLOW_NOTHING;

        synchronized (this) {
            for ( int i = 0; i < groupPermission.size(); i++ ) {
                GroupPermission group = (GroupPermission) groupPermission.get(i);
                if ( group.getId().toString().equals( groupId ) ) {
                    allowedPermission = group.getPermission();
                    break;
                }
            }
        }
        if ( (allowedPermission & permission) == permission ) {
          check = true;
        }
        return check;
    }

    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append( "Permissions:\n\tlevelInclusion=" + levelInclusion + "\n" );
        if ( groupPermission == null ) {
            sb.append( "\tSecurity groups aren't defined\n" );
        } else {
            sb.append( "\tSecurity groups:\n" );
            for ( int i = 0; i < groupPermission.size(); i++ ) {
                sb.append( groupPermission.get(i).toString() );
            }
        }
        return sb.toString();
    }

}

//End Permission class

