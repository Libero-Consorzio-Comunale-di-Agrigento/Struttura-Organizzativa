//AmvStileAggiornaModel imports @1-E6BEC34F
package restrict.AmvStileAggiorna;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvStileAggiornaModel imports

//AmvStileAggiornaModel class head @1-FF0953C8
public class AmvStileAggiornaModel extends com.codecharge.components.Page {
    public AmvStileAggiornaModel() {
        this( new CCSLocale(), null );
    }

    public AmvStileAggiornaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvStileAggiornaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvStileAggiornaModel class head

//page settings @1-B4B7150D
        super("AmvStileAggiorna", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//STILE record @2-AB075038
        
        /*
            Model of STILE record defining.
        */
        {
            com.codecharge.components.Record STILE = new com.codecharge.components.Record("STILE");
            STILE.setPageModel( this );
            STILE.addExcludeParam( "ccsForm" );
            STILE.setVisible( true );
            STILE.setAllowInsert(false);
            STILE.setAllowDelete(false);
            STILE.setPreserveType(PreserveParameterType.NONE);
            STILE.setReturnPage("AmvStileAggiorna" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox P_UTENTE__3 = new com.codecharge.components.TextBox("P_UTENTE", "P_UTENTE", this );
            P_UTENTE__3.setType( com.codecharge.components.ControlType.TEXT );
            P_UTENTE__3.setHtmlEncode( true );
            STILE.add( P_UTENTE__3 );

            com.codecharge.components.TextBox P_STRINGA__13 = new com.codecharge.components.TextBox("P_STRINGA", "P_STRINGA", this );
            P_STRINGA__13.setType( com.codecharge.components.ControlType.TEXT );
            P_STRINGA__13.setHtmlEncode( true );
            STILE.add( P_STRINGA__13 );

            com.codecharge.components.TextBox P_MODULO__14 = new com.codecharge.components.TextBox("P_MODULO", "P_MODULO", this );
            P_MODULO__14.setType( com.codecharge.components.ControlType.TEXT );
            P_MODULO__14.setHtmlEncode( true );
            STILE.add( P_MODULO__14 );

            com.codecharge.components.TextBox P_STYLESHEET__15 = new com.codecharge.components.TextBox("P_STYLESHEET", "P_STYLESHEET", this );
            P_STYLESHEET__15.setType( com.codecharge.components.ControlType.TEXT );
            P_STYLESHEET__15.setHtmlEncode( true );
            STILE.add( P_STYLESHEET__15 );

            com.codecharge.components.Button Button_Insert__5 = new com.codecharge.components.Button("Button_Insert", this);
            Button_Insert__5.addExcludeParam( "ccsForm" );
            Button_Insert__5.addExcludeParam( "Button_Insert" );
            Button_Insert__5.setOperation( "Insert" );
            STILE.add( Button_Insert__5 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Update" );
            STILE.add( Button_Update__6 );

            com.codecharge.components.Button Button_Delete__7 = new com.codecharge.components.Button("Button_Delete", this);
            Button_Delete__7.addExcludeParam( "ccsForm" );
            Button_Delete__7.addExcludeParam( "Button_Delete" );
            Button_Delete__7.setOperation( "Delete" );
            STILE.add( Button_Delete__7 );
            add(STILE);
        } // End definition of STILE record model.
//End STILE record

//AmvStileAggiornaModel class tail @1-F5FC18C5
    }
}
//End AmvStileAggiornaModel class tail

