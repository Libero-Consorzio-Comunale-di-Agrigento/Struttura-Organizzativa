//AmvAccessiAreeDocModel imports @1-9E73152F
package restrict.AmvAccessiAreeDoc;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAccessiAreeDocModel imports

//AmvAccessiAreeDocModel class head @1-634D42D6
public class AmvAccessiAreeDocModel extends com.codecharge.components.Page {
    public AmvAccessiAreeDocModel() {
        this( new CCSLocale(), null );
    }

    public AmvAccessiAreeDocModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAccessiAreeDocModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAccessiAreeDocModel class head

//page settings @1-3AC9C3BE
        super("AmvAccessiAreeDoc", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__4 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__4.setVisible( true );
            add( AmvGuida__4 );
            com.codecharge.components.IncludePage Footer__5 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__5.setVisible( true );
            add( Footer__5 );
        } // end page
//End page settings

//AMV_DIRITTI grid @6-26C89242
        
        /*
            // Begin definition of AMV_DIRITTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_DIRITTI = new com.codecharge.components.Grid("AMV_DIRITTI");
            AMV_DIRITTI.setPageModel( this );
            AMV_DIRITTI.setFetchSize(20);
            AMV_DIRITTI.setVisible( true );
            AMV_DIRITTI.addGridListener( new AMV_DIRITTIGridHandler() );

            com.codecharge.components.Label AREA__7 = new com.codecharge.components.Label("AREA", "AREA", this );
            AREA__7.setType( com.codecharge.components.ControlType.TEXT );
            AREA__7.setHtmlEncode( true );
            AMV_DIRITTI.add(AREA__7);

            com.codecharge.components.Label TIPOLOGIA__10 = new com.codecharge.components.Label("TIPOLOGIA", "TIPOLOGIA", this );
            TIPOLOGIA__10.setType( com.codecharge.components.ControlType.TEXT );
            TIPOLOGIA__10.setHtmlEncode( true );
            AMV_DIRITTI.add(TIPOLOGIA__10);

            com.codecharge.components.Label DES_ACCESSO__11 = new com.codecharge.components.Label("DES_ACCESSO", "DES_ACCESSO", this );
            DES_ACCESSO__11.setType( com.codecharge.components.ControlType.TEXT );
            DES_ACCESSO__11.setHtmlEncode( true );
            AMV_DIRITTI.add(DES_ACCESSO__11);

            com.codecharge.components.Label GRUPPO__8 = new com.codecharge.components.Label("GRUPPO", "GRUPPO", this );
            GRUPPO__8.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPO__8.setHtmlEncode( true );
            AMV_DIRITTI.add(GRUPPO__8);

            com.codecharge.components.Label AFCNavigator__12 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__12.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DIRITTI.add(AFCNavigator__12);
            add(AMV_DIRITTI);
        } // End definition of AMV_DIRITTI grid model
//End AMV_DIRITTI grid

//AmvAccessiAreeDocModel class tail @1-F5FC18C5
    }
}
//End AmvAccessiAreeDocModel class tail

