//AmvLogerrModel imports @1-1F91BB56
package common.AmvLogerr;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLogerrModel imports

//AmvLogerrModel class head @1-4599F1A1
public class AmvLogerrModel extends com.codecharge.components.Page {
    public AmvLogerrModel() {
        this( new CCSLocale(), null );
    }

    public AmvLogerrModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLogerrModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLogerrModel class head

//page settings @1-BE8E0CD7
        super("AmvLogerr", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvLogerrModel class tail @1-F5FC18C5
    }
}
//End AmvLogerrModel class tail

