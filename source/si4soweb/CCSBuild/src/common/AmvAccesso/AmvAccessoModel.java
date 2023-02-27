//AmvAccessoModel imports @1-A767B7BC
package common.AmvAccesso;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAccessoModel imports

//AmvAccessoModel class head @1-8D6797B6
public class AmvAccessoModel extends com.codecharge.components.Page {
    public AmvAccessoModel() {
        this( new CCSLocale(), null );
    }

    public AmvAccessoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAccessoModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAccessoModel class head

//page settings @1-31E599E8
        super("AmvAccesso", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//CONTROLLO_PASSWORD grid @9-DD218C07
        
        /*
            // Begin definition of CONTROLLO_PASSWORD grid model.
        */
        {
            com.codecharge.components.Grid CONTROLLO_PASSWORD = new com.codecharge.components.Grid("CONTROLLO_PASSWORD");
            CONTROLLO_PASSWORD.setPageModel( this );
            CONTROLLO_PASSWORD.setFetchSize(100);
            CONTROLLO_PASSWORD.setVisible( true );
            CONTROLLO_PASSWORD.addGridListener( new CONTROLLO_PASSWORDGridHandler() );

            com.codecharge.components.Label PWD__10 = new com.codecharge.components.Label("PWD", "PWD", this );
            PWD__10.setType( com.codecharge.components.ControlType.TEXT );
            PWD__10.setHtmlEncode( true );
            CONTROLLO_PASSWORD.add(PWD__10);
            add(CONTROLLO_PASSWORD);
        } // End definition of CONTROLLO_PASSWORD grid model
//End CONTROLLO_PASSWORD grid

//AmvAccessoModel class tail @1-F5FC18C5
    }
}
//End AmvAccessoModel class tail

