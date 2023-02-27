//AmvRightDocModel imports @1-89BB0DD4
package common.AmvRightDoc;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRightDocModel imports

//AmvRightDocModel class head @1-B7343DC7
public class AmvRightDocModel extends com.codecharge.components.Page {
    public AmvRightDocModel() {
        this( new CCSLocale(), null );
    }

    public AmvRightDocModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRightDocModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRightDocModel class head

//page settings @1-1872897F
        super("AmvRightDoc", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Zona_D grid @34-7A9E6B1A
        
        /*
            // Begin definition of Zona_D grid model.
        */
        {
            com.codecharge.components.Grid Zona_D = new com.codecharge.components.Grid("Zona_D");
            Zona_D.setPageModel( this );
            Zona_D.setFetchSize(20);
            Zona_D.setVisible( true );

            com.codecharge.components.Label ZONA_D__35 = new com.codecharge.components.Label("ZONA_D", "BLOCCO", this );
            ZONA_D__35.setType( com.codecharge.components.ControlType.TEXT );
            Zona_D.add(ZONA_D__35);
            add(Zona_D);
        } // End definition of Zona_D grid model
//End Zona_D grid

//AmvRightDocModel class tail @1-F5FC18C5
    }
}
//End AmvRightDocModel class tail


