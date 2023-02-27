//AmvLogoutModel imports @1-15180FEB
package common.AmvLogout;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLogoutModel imports

//AmvLogoutModel class head @1-22908879
public class AmvLogoutModel extends com.codecharge.components.Page {
    public AmvLogoutModel() {
        this( new CCSLocale(), null );
    }

    public AmvLogoutModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLogoutModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLogoutModel class head

//page settings @1-00BB1913
        super("AmvLogout", locale );
        setResponse(response);
        addPageListener(new AmvLogoutPageHandler());
        {

            com.codecharge.components.Label cookies__4 = new com.codecharge.components.Label("cookies", "", this );
            cookies__4.setType( com.codecharge.components.ControlType.TEXT );
            cookies__4.setHtmlEncode( true );
            add( cookies__4 );
        } // end page
//End page settings

//AmvLogoutModel class tail @1-F5FC18C5
    }
}
//End AmvLogoutModel class tail

