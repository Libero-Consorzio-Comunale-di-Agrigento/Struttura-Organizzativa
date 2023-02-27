//AmvNavigatoreModel imports @1-10BECFFE
package common.AmvNavigatore;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvNavigatoreModel imports

//AmvNavigatoreModel class head @1-7FF27240
public class AmvNavigatoreModel extends com.codecharge.components.Page {
    public AmvNavigatoreModel() {
        this( new CCSLocale(), null );
    }

    public AmvNavigatoreModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvNavigatoreModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvNavigatoreModel class head

//page settings @1-1DCD30C8
        super("AmvNavigatore", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//NAVIGATORE grid @2-496C748A
        
        /*
            // Begin definition of NAVIGATORE grid model.
        */
        {
            com.codecharge.components.Grid NAVIGATORE = new com.codecharge.components.Grid("NAVIGATORE");
            NAVIGATORE.setPageModel( this );
            NAVIGATORE.setFetchSize(20);
            NAVIGATORE.setVisible( true );

            com.codecharge.components.Label NAVIGATORE_SEZIONI__3 = new com.codecharge.components.Label("NAVIGATORE_SEZIONI", "NAVIGATORE_SEZIONI", this );
            NAVIGATORE_SEZIONI__3.setType( com.codecharge.components.ControlType.TEXT );
            NAVIGATORE.add(NAVIGATORE_SEZIONI__3);
            add(NAVIGATORE);
        } // End definition of NAVIGATORE grid model
//End NAVIGATORE grid

//AmvNavigatoreModel class tail @1-F5FC18C5
    }
}
//End AmvNavigatoreModel class tail

