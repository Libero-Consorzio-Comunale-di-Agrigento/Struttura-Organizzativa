//VersioneModel imports @1-36A9539E
package common.Versione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End VersioneModel imports

//VersioneModel class head @1-92A4854B
public class VersioneModel extends com.codecharge.components.Page {
    public VersioneModel() {
        this( new CCSLocale(), null );
    }

    public VersioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public VersioneModel( CCSLocale locale, HttpServletResponse response ) {
//End VersioneModel class head

//page settings @1-AB779945
        super("Versione", locale );
        setResponse(response);
        setIncluded(true);
        addPageListener(new VersionePageHandler());
        {

            com.codecharge.components.Label VERSIONE__2 = new com.codecharge.components.Label("VERSIONE", this);
            VERSIONE__2.setType( com.codecharge.components.ControlType.TEXT );
            VERSIONE__2.setHtmlEncode( true );
            add( VERSIONE__2 );
        } // end page
//End page settings

//VersioneModel class tail @1-F5FC18C5
    }
}
//End VersioneModel class tail

