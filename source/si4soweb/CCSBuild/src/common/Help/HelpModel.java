//HelpModel imports @1-2B4E9B69
package common.Help;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End HelpModel imports

//HelpModel class head @1-0374FDFD
public class HelpModel extends com.codecharge.components.Page {
    public HelpModel() {
        this( new CCSLocale(), null );
    }

    public HelpModel(CCSLocale locale) {
        this( locale, null );
    }

    public HelpModel( CCSLocale locale, HttpServletResponse response ) {
//End HelpModel class head

//page settings @1-763FD535
        super("Help", locale );
        setResponse(response);
        addPageListener(new HelpPageHandler());
        {
        } // end page
//End page settings

//HelpModel class tail @1-F5FC18C5
    }
}
//End HelpModel class tail

