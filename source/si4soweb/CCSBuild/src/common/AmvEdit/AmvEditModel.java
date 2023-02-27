//AmvEditModel imports @1-4879B378
package common.AmvEdit;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvEditModel imports

//AmvEditModel class head @1-13A9DC73
public class AmvEditModel extends com.codecharge.components.Page {
    public AmvEditModel() {
        this( new CCSLocale(), null );
    }

    public AmvEditModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvEditModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvEditModel class head

//page settings @1-B7C41188
        super("AmvEdit", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__12 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__12.setVisible( true );
            add( AmvStyle__12 );
        } // end page
//End page settings

//NOTE record @2-0FF4AF6B
        
        /*
            Model of NOTE record defining.
        */
        {
            com.codecharge.components.Record NOTE = new com.codecharge.components.Record("NOTE");
            NOTE.setPageModel( this );
            NOTE.addExcludeParam( "ccsForm" );
            NOTE.setVisible( true );
            NOTE.setAllowInsert(false);
            NOTE.setAllowDelete(false);
            NOTE.setPreserveType(PreserveParameterType.GET);
            NOTE.setReturnPage("AmvEdit" + Names.ACTION_SUFFIX);
            NOTE.addRecordListener(new NOTERecordHandler());

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__10.setHtmlEncode( true );
            NOTE.add(TITOLO__10);

            com.codecharge.components.TextArea VALORE__3 = new com.codecharge.components.TextArea("VALORE", "", this );
            VALORE__3.setType( com.codecharge.components.ControlType.MEMO );
            VALORE__3.setHtmlEncode( true );
            NOTE.add( VALORE__3 );

            com.codecharge.components.Label INPUT_FILE__22 = new com.codecharge.components.Label("INPUT_FILE", "INPUT_FILE", this );
            INPUT_FILE__22.setType( com.codecharge.components.ControlType.TEXT );
            NOTE.add(INPUT_FILE__22);

            com.codecharge.components.Hidden MOSTRA__27 = new com.codecharge.components.Hidden("MOSTRA", "MOSTRA", this );
            MOSTRA__27.setType( com.codecharge.components.ControlType.TEXT );
            MOSTRA__27.setHtmlEncode( true );
            NOTE.add( MOSTRA__27 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Update" );
            NOTE.add( Button_Update__6 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            NOTE.add( Annulla__11 );
            add(NOTE);
        } // End definition of NOTE record model.
//End NOTE record

//AmvEditModel class tail @1-F5FC18C5
    }
}
//End AmvEditModel class tail


