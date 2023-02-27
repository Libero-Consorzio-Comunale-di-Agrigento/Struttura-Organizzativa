//HeaderModel imports @1-63FCE662
package common.Header;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End HeaderModel imports

//HeaderModel class head @1-84F6659A
public class HeaderModel extends com.codecharge.components.Page {
    public HeaderModel() {
        this( new CCSLocale(), null );
    }

    public HeaderModel(CCSLocale locale) {
        this( locale, null );
    }

    public HeaderModel( CCSLocale locale, HttpServletResponse response ) {
//End HeaderModel class head

//page settings @1-3DC9F788
        super("Header", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvHeader__2 = new com.codecharge.components.IncludePage("AmvHeader", this );
            AmvHeader__2.setVisible( true );
            add( AmvHeader__2 );
        } // end page
//End page settings

//HeaderModel class tail @1-F5FC18C5
    }
}
//End HeaderModel class tail

