//AmvLeftMenuSezioniModel imports @1-C8D313B8
package common.AmvLeftMenuSezioni;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLeftMenuSezioniModel imports

//AmvLeftMenuSezioniModel class head @1-00AEEBA8
public class AmvLeftMenuSezioniModel extends com.codecharge.components.Page {
    public AmvLeftMenuSezioniModel() {
        this( new CCSLocale(), null );
    }

    public AmvLeftMenuSezioniModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLeftMenuSezioniModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLeftMenuSezioniModel class head

//page settings @1-7B11D4F2
        super("AmvLeftMenuSezioni", locale );
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

//AmvLeftMenuSezioniModel class tail @1-F5FC18C5
    }
}
//End AmvLeftMenuSezioniModel class tail
