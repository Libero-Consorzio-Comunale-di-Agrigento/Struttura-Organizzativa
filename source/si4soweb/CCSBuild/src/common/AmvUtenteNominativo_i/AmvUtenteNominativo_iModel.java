//AmvUtenteNominativo_iModel imports @1-4FFCCD7D
package common.AmvUtenteNominativo_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtenteNominativo_iModel imports

//AmvUtenteNominativo_iModel class head @1-D6E0D412
public class AmvUtenteNominativo_iModel extends com.codecharge.components.Page {
    public AmvUtenteNominativo_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtenteNominativo_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtenteNominativo_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtenteNominativo_iModel class head

//page settings @1-F8D4546C
        super("AmvUtenteNominativo_i", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//UTENTE_CONTROL grid @2-D280F9A7
        
        /*
            // Begin definition of UTENTE_CONTROL grid model.
        */
        {
            com.codecharge.components.Grid UTENTE_CONTROL = new com.codecharge.components.Grid("UTENTE_CONTROL");
            UTENTE_CONTROL.setPageModel( this );
            UTENTE_CONTROL.setFetchSize(20);
            UTENTE_CONTROL.setVisible( true );

            com.codecharge.components.Label NOMINATIVO__3 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__3.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__3.setHtmlEncode( true );
            UTENTE_CONTROL.add(NOMINATIVO__3);
            add(UTENTE_CONTROL);
        } // End definition of UTENTE_CONTROL grid model
//End UTENTE_CONTROL grid

//AmvUtenteNominativo_iModel class tail @1-F5FC18C5
    }
}
//End AmvUtenteNominativo_iModel class tail

