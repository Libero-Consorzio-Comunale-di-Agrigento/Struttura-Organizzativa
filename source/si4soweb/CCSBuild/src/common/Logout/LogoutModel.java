//LogoutModel imports @1-0E274F18
package common.Logout;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End LogoutModel imports

//LogoutModel class head @1-B5F7CB2F
public class LogoutModel extends com.codecharge.components.Page {
    public LogoutModel() {
        this( new CCSLocale(), null );
    }

    public LogoutModel(CCSLocale locale) {
        this( locale, null );
    }

    public LogoutModel( CCSLocale locale, HttpServletResponse response ) {
//End LogoutModel class head

//page settings @1-660CBFAC
        super("Logout", locale );
        setResponse(response);
        addPageListener(new LogoutPageHandler());
        {
        } // end page
//End page settings

//LogoutModel class tail @1-F5FC18C5
    }
}
//End LogoutModel class tail

