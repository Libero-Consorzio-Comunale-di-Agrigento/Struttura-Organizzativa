//AmvLeftDocModel imports @1-9CA64F2A
package common.AmvLeftDoc;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLeftDocModel imports

//AmvLeftDocModel class head @1-FDE53E06
public class AmvLeftDocModel extends com.codecharge.components.Page {
    public AmvLeftDocModel() {
        this( new CCSLocale(), null );
    }

    public AmvLeftDocModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLeftDocModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLeftDocModel class head

//page settings @1-39DA32DD
        super("AmvLeftDoc", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Zona_S grid @34-909133A3
        
        /*
            // Begin definition of Zona_S grid model.
        */
        {
            com.codecharge.components.Grid Zona_S = new com.codecharge.components.Grid("Zona_S");
            Zona_S.setPageModel( this );
            Zona_S.setFetchSize(20);
            Zona_S.setVisible( true );

            com.codecharge.components.Label ZONA_S__35 = new com.codecharge.components.Label("ZONA_S", "BLOCCO", this );
            ZONA_S__35.setType( com.codecharge.components.ControlType.TEXT );
            Zona_S.add(ZONA_S__35);
            add(Zona_S);
        } // End definition of Zona_S grid model
//End Zona_S grid

//AmvLeftDocModel class tail @1-F5FC18C5
    }
}
//End AmvLeftDocModel class tail

