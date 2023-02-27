//AmvModSelectModel imports @1-F149A696
package common.AmvModSelect;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvModSelectModel imports

//AmvModSelectModel class head @1-51E38144
public class AmvModSelectModel extends com.codecharge.components.Page {
    public AmvModSelectModel() {
        this( new CCSLocale(), null );
    }

    public AmvModSelectModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvModSelectModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvModSelectModel class head

//page settings @1-EBC698F1
        super("AmvModSelect", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-FF95CEA5
        
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
            FILE_LIST.setReturnPage("AmvModSelect" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.ListBox MODELLO__27 = new com.codecharge.components.ListBox("MODELLO", "VALORE", this );
            MODELLO__27.setType( com.codecharge.components.ControlType.TEXT );
            MODELLO__27.setHtmlEncode( true );
            MODELLO__27.setBoundColumn( "CODICE" );
            MODELLO__27.setTextColumn( "CODICE_MODELLO" );
            FILE_LIST.add( MODELLO__27 );

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

//AmvModSelectModel class tail @1-F5FC18C5
    }
}
//End AmvModSelectModel class tail

