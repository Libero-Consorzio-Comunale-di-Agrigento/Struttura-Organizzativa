//AmvServiziRichiestiElenco_iModel imports @1-F6DA37B0
package common.AmvServiziRichiestiElenco_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziRichiestiElenco_iModel imports

//AmvServiziRichiestiElenco_iModel class head @1-FA47B063
public class AmvServiziRichiestiElenco_iModel extends com.codecharge.components.Page {
    public AmvServiziRichiestiElenco_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziRichiestiElenco_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziRichiestiElenco_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziRichiestiElenco_iModel class head

//page settings @1-FCE44C2D
        super("AmvServiziRichiestiElenco_i", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//SERVIZI_RICHIESTI grid @2-E889F990
        
        /*
            // Begin definition of SERVIZI_RICHIESTI grid model.
        */
        {
            com.codecharge.components.Grid SERVIZI_RICHIESTI = new com.codecharge.components.Grid("SERVIZI_RICHIESTI");
            SERVIZI_RICHIESTI.setPageModel( this );
            SERVIZI_RICHIESTI.setFetchSize(10);
            SERVIZI_RICHIESTI.setVisible( true );
            SERVIZI_RICHIESTI.addGridListener( new SERVIZI_RICHIESTIGridHandler() );

            com.codecharge.components.Label DATA__4 = new com.codecharge.components.Label("DATA", "DATA", this );
            DATA__4.setType( com.codecharge.components.ControlType.TEXT );
            DATA__4.setHtmlEncode( true );
            SERVIZI_RICHIESTI.add(DATA__4);

            com.codecharge.components.Label SERVIZIO__3 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__3.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__3.setHtmlEncode( true );
            SERVIZI_RICHIESTI.add(SERVIZIO__3);

            com.codecharge.components.Label NOTIFICA__5 = new com.codecharge.components.Label("NOTIFICA", "NOTIFICA", this );
            NOTIFICA__5.setType( com.codecharge.components.ControlType.TEXT );
            NOTIFICA__5.setHtmlEncode( true );
            SERVIZI_RICHIESTI.add(NOTIFICA__5);

            com.codecharge.components.Label AZIENDA__6 = new com.codecharge.components.Label("AZIENDA", "AZIENDA", this );
            AZIENDA__6.setType( com.codecharge.components.ControlType.TEXT );
            AZIENDA__6.setHtmlEncode( true );
            SERVIZI_RICHIESTI.add(AZIENDA__6);

            com.codecharge.components.Label AFCNavigator__37 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__37.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZI_RICHIESTI.add(AFCNavigator__37);
            add(SERVIZI_RICHIESTI);
        } // End definition of SERVIZI_RICHIESTI grid model
//End SERVIZI_RICHIESTI grid

//AmvServiziRichiestiElenco_iModel class tail @1-F5FC18C5
    }
}
//End AmvServiziRichiestiElenco_iModel class tail
