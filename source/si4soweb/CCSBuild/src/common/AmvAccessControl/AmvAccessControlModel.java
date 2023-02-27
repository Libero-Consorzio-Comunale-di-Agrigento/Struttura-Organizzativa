//AmvAccessControlModel imports @1-86A69FE2
package common.AmvAccessControl;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAccessControlModel imports

//AmvAccessControlModel class head @1-741B38E6
public class AmvAccessControlModel extends com.codecharge.components.Page {
    public AmvAccessControlModel() {
        this( new CCSLocale(), null );
    }

    public AmvAccessControlModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAccessControlModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAccessControlModel class head

//page settings @1-ABB8783E
        super("AmvAccessControl", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//ACCESSO grid @3-151E596F
        
        /*
            // Begin definition of ACCESSO grid model.
        */
        {
            com.codecharge.components.Grid ACCESSO = new com.codecharge.components.Grid("ACCESSO");
            ACCESSO.setPageModel( this );
            ACCESSO.setFetchSize(100);
            ACCESSO.setVisible( true );
            ACCESSO.addGridListener( new ACCESSOGridHandler() );

            com.codecharge.components.Label VOCE__4 = new com.codecharge.components.Label("VOCE", "VOCE", this );
            VOCE__4.setType( com.codecharge.components.ControlType.TEXT );
            VOCE__4.setHtmlEncode( true );
            VOCE__4.addControlListener( new ACCESSOVOCEHandler());
            ACCESSO.add(VOCE__4);
            add(ACCESSO);
        } // End definition of ACCESSO grid model
//End ACCESSO grid

//AmvAccessControlModel class tail @1-F5FC18C5
    }
}
//End AmvAccessControlModel class tail

