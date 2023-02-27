//AmvRightMenuSezioniModel imports @1-E6EE7827
package common.AmvRightMenuSezioni;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRightMenuSezioniModel imports

//AmvRightMenuSezioniModel class head @1-B6C03CED
public class AmvRightMenuSezioniModel extends com.codecharge.components.Page {
    public AmvRightMenuSezioniModel() {
        this( new CCSLocale(), null );
    }

    public AmvRightMenuSezioniModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRightMenuSezioniModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRightMenuSezioniModel class head

//page settings @1-B8E5BA6E
        super("AmvRightMenuSezioni", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//MENU_SEZIONI grid @79-9AA5E3F0
        
        /*
            // Begin definition of MENU_SEZIONI grid model.
        */
        {
            com.codecharge.components.Grid MENU_SEZIONI = new com.codecharge.components.Grid("MENU_SEZIONI");
            MENU_SEZIONI.setPageModel( this );
            MENU_SEZIONI.setFetchSize(20);
            MENU_SEZIONI.setVisible( true );

            com.codecharge.components.Label MENU_SEZ__80 = new com.codecharge.components.Label("MENU_SEZ", "BLOCCO", this );
            MENU_SEZ__80.setType( com.codecharge.components.ControlType.TEXT );
            MENU_SEZIONI.add(MENU_SEZ__80);
            add(MENU_SEZIONI);
        } // End definition of MENU_SEZIONI grid model
//End MENU_SEZIONI grid

//AmvRightMenuSezioniModel class tail @1-F5FC18C5
    }
}
//End AmvRightMenuSezioniModel class tail
