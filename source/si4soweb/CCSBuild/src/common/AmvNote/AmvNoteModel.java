//AmvNoteModel imports @1-A7BA5C83
package common.AmvNote;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvNoteModel imports

//AmvNoteModel class head @1-954D48B8
public class AmvNoteModel extends com.codecharge.components.Page {
    public AmvNoteModel() {
        this( new CCSLocale(), null );
    }

    public AmvNoteModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvNoteModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvNoteModel class head

//page settings @1-45343DC6
        super("AmvNote", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__12 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__12.setVisible( true );
            add( AmvStyle__12 );
        } // end page
//End page settings

//NOTE record @2-E5DB9D12
        
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
            NOTE.setReturnPage("AmvNote" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__10.setHtmlEncode( true );
            NOTE.add(TITOLO__10);

            com.codecharge.components.TextArea VALORE__3 = new com.codecharge.components.TextArea("VALORE", "VALORE", this );
            VALORE__3.setType( com.codecharge.components.ControlType.MEMO );
            VALORE__3.setHtmlEncode( true );
            NOTE.add( VALORE__3 );

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

//AmvNoteModel class tail @1-F5FC18C5
    }
}
//End AmvNoteModel class tail

