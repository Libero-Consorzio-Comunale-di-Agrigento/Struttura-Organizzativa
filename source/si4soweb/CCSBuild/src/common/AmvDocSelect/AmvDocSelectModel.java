//AmvDocSelectModel imports @1-D83DA447
package common.AmvDocSelect;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocSelectModel imports

//AmvDocSelectModel class head @1-AA2CEF28
public class AmvDocSelectModel extends com.codecharge.components.Page {
    public AmvDocSelectModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocSelectModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocSelectModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocSelectModel class head

//page settings @1-3F3614AC
        super("AmvDocSelect", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-EAFA8F5F
        
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
            FILE_LIST.setReturnPage("AmvDocSelect" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.ListBox DOCUMENTO__27 = new com.codecharge.components.ListBox("DOCUMENTO", "VALORE", this );
            DOCUMENTO__27.setType( com.codecharge.components.ControlType.TEXT );
            DOCUMENTO__27.setHtmlEncode( true );
            DOCUMENTO__27.setBoundColumn( "VALORE" );
            DOCUMENTO__27.setTextColumn( "TITOLO" );
            FILE_LIST.add( DOCUMENTO__27 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Update" );
            FILE_LIST.add( Button_Update__6 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            FILE_LIST.add( Annulla__11 );
            add(FILE_LIST);
        } // End definition of FILE_LIST record model.
//End FILE_LIST record

//AmvDocSelectModel class tail @1-F5FC18C5
    }
}
//End AmvDocSelectModel class tail
