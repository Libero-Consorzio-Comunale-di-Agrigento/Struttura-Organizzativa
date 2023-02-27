//AmvDocUrlModel imports @1-4C967845
package common.AmvDocUrl;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocUrlModel imports

//AmvDocUrlModel class head @1-B6F7075E
public class AmvDocUrlModel extends com.codecharge.components.Page {
    public AmvDocUrlModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocUrlModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocUrlModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocUrlModel class head

//page settings @1-82A8AA6C
        super("AmvDocUrl", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-D0D980E0
        
        /*
            Model of FILE_LIST record defining.
        */
        {
            com.codecharge.components.Record FILE_LIST = new com.codecharge.components.Record("FILE_LIST");
            FILE_LIST.setPageModel( this );
            FILE_LIST.addExcludeParam( "ccsForm" );
            FILE_LIST.setVisible( true );
            FILE_LIST.setAllowInsert(false);
            FILE_LIST.setAllowDelete(false);
            FILE_LIST.setPreserveType(PreserveParameterType.GET);
            FILE_LIST.setReturnPage("AmvDocUrl" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.ListBox DOCUMENTO__27 = new com.codecharge.components.ListBox("DOCUMENTO", "VALORE", this );
            DOCUMENTO__27.setType( com.codecharge.components.ControlType.TEXT );
            DOCUMENTO__27.setHtmlEncode( true );
            DOCUMENTO__27.setBoundColumn( "VALORE" );
            DOCUMENTO__27.setTextColumn( "TITOLO" );
            FILE_LIST.add( DOCUMENTO__27 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            FILE_LIST.add( Annulla__11 );
            add(FILE_LIST);
        } // End definition of FILE_LIST record model.
//End FILE_LIST record

//AmvDocUrlModel class tail @1-F5FC18C5
    }
}
//End AmvDocUrlModel class tail
