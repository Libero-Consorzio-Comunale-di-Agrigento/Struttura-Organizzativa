//DeniedModel imports @1-599F38E5
package common.Denied;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End DeniedModel imports

//DeniedModel class head @1-6EF8D87D
public class DeniedModel extends com.codecharge.components.Page {
    public DeniedModel() {
        this( new CCSLocale(), null );
    }

    public DeniedModel(CCSLocale locale) {
        this( locale, null );
    }

    public DeniedModel( CCSLocale locale, HttpServletResponse response ) {
//End DeniedModel class head

//page settings @1-12540643
        super("Denied", locale );
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

//DeniedModel class tail @1-F5FC18C5
    }
}
//End DeniedModel class tail


