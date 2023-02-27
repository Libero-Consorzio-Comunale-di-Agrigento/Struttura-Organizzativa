//AmvUtenteControl_iModel imports @1-A05250C2
package common.AmvUtenteControl_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtenteControl_iModel imports

//AmvUtenteControl_iModel class head @1-3F886F0A
public class AmvUtenteControl_iModel extends com.codecharge.components.Page {
    public AmvUtenteControl_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtenteControl_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtenteControl_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtenteControl_iModel class head

//page settings @1-C3C23BAE
        super("AmvUtenteControl_i", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//UTENTE_CONTROL grid @2-947C3309
        
        /*
            // Begin definition of UTENTE_CONTROL grid model.
        */
        {
            com.codecharge.components.Grid UTENTE_CONTROL = new com.codecharge.components.Grid("UTENTE_CONTROL");
            UTENTE_CONTROL.setPageModel( this );
            UTENTE_CONTROL.setFetchSize(20);
            UTENTE_CONTROL.setVisible( true );

            com.codecharge.components.Label Utente__3 = new com.codecharge.components.Label("Utente", "UTENTE", this );
            Utente__3.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE_CONTROL.add(Utente__3);
            add(UTENTE_CONTROL);
        } // End definition of UTENTE_CONTROL grid model
//End UTENTE_CONTROL grid

//AmvUtenteControl_iModel class tail @1-F5FC18C5
    }
}
//End AmvUtenteControl_iModel class tail

