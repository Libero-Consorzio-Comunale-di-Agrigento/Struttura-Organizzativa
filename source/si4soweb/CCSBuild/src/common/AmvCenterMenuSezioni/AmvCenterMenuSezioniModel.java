//AmvCenterMenuSezioniModel imports @1-F1A398E5
package common.AmvCenterMenuSezioni;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvCenterMenuSezioniModel imports

//AmvCenterMenuSezioniModel class head @1-B6D04263
public class AmvCenterMenuSezioniModel extends com.codecharge.components.Page {
    public AmvCenterMenuSezioniModel() {
        this( new CCSLocale(), null );
    }

    public AmvCenterMenuSezioniModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvCenterMenuSezioniModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvCenterMenuSezioniModel class head

//page settings @1-7B9DDBD8
        super("AmvCenterMenuSezioni", locale );
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

//AmvCenterMenuSezioniModel class tail @1-F5FC18C5
    }
}
//End AmvCenterMenuSezioniModel class tail
