//GuidaModel imports @1-28AE2201
package common.Guida;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End GuidaModel imports

//GuidaModel class head @1-8BA0354E
public class GuidaModel extends com.codecharge.components.Page {
    public GuidaModel() {
        this( new CCSLocale(), null );
    }

    public GuidaModel(CCSLocale locale) {
        this( locale, null );
    }

    public GuidaModel( CCSLocale locale, HttpServletResponse response ) {
//End GuidaModel class head

//page settings @1-29D75698
        super("Guida", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvGuida__2 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__2.setVisible( true );
            add( AmvGuida__2 );
        } // end page
//End page settings

//GuidaModel class tail @1-F5FC18C5
    }
}
//End GuidaModel class tail

