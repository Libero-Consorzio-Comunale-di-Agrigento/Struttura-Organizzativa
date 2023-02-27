//AmvRegistrazioneFineModel imports @1-7F4DA3DC
package common.AmvRegistrazioneFine;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRegistrazioneFineModel imports

//AmvRegistrazioneFineModel class head @1-796854A1
public class AmvRegistrazioneFineModel extends com.codecharge.components.Page {
    public AmvRegistrazioneFineModel() {
        this( new CCSLocale(), null );
    }

    public AmvRegistrazioneFineModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRegistrazioneFineModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRegistrazioneFineModel class head

//page settings @1-21556952
        super("AmvRegistrazioneFine", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage AmvServiziElenco__6 = new com.codecharge.components.IncludePage("AmvServiziElenco", this );
            AmvServiziElenco__6.setVisible( true );
            add( AmvServiziElenco__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//MESSAGGIO_RICHIESTA grid @7-C4F25D53
        
        /*
            // Begin definition of MESSAGGIO_RICHIESTA grid model.
        */
        {
            com.codecharge.components.Grid MESSAGGIO_RICHIESTA = new com.codecharge.components.Grid("MESSAGGIO_RICHIESTA");
            MESSAGGIO_RICHIESTA.setPageModel( this );
            MESSAGGIO_RICHIESTA.setFetchSize(20);
            MESSAGGIO_RICHIESTA.setVisible( true );

            com.codecharge.components.Label MSG__8 = new com.codecharge.components.Label("MSG", "MSG", this );
            MSG__8.setType( com.codecharge.components.ControlType.TEXT );
            MESSAGGIO_RICHIESTA.add(MSG__8);
            add(MESSAGGIO_RICHIESTA);
        } // End definition of MESSAGGIO_RICHIESTA grid model
//End MESSAGGIO_RICHIESTA grid

//AmvRegistrazioneFineModel class tail @1-F5FC18C5
    }
}
//End AmvRegistrazioneFineModel class tail

