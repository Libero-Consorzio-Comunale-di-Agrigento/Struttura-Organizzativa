//IRecord interface @0-194E17B2
package com.codecharge.components;

import com.codecharge.util.*;

public interface IRecord {

    void setReturnPage(String page);
    String getReturnPage();

    boolean isRestricted();
    boolean isVisible();
    void setVisible( boolean visible );
    boolean isAllowRead();
    void setAllowRead( boolean allowRead );
    boolean isAllowInsert();
    void setAllowInsert( boolean allowInsert );
    boolean isAllowUpdate();
    void setAllowUpdate( boolean allowUpdate );
    boolean isAllowDelete();
    void setAllowDelete( boolean allowDelete );

    public String getFormEnctype();
    Permission getPermissions();
    boolean hasReadPermission( int groupId );
    boolean hasInsertPermission( int groupId );
    boolean hasUpdatePermission( int groupId );
    boolean hasDeletePermission( int groupId );

    PreserveParameterType getPreserveType();
    void setPreserveType( PreserveParameterType type );

}

//End IRecord interface

