//AmvHelpModel imports @1-A0B1158E
package common.AmvHelp;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvHelpModel imports

//AmvHelpModel class head @1-4781E846
public class AmvHelpModel extends com.codecharge.components.Page {
    public AmvHelpModel() {
        this( new CCSLocale(), null );
    }

    public AmvHelpModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvHelpModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvHelpModel class head

//page settings @1-3C1C4820
        super("AmvHelp", locale );
        setResponse(response);
        setIncluded(true);
        addPageListener(new AmvHelpPageHandler());
        {
        } // end page
//End page settings

//AmvHelpModel class tail @1-F5FC18C5
    }
}
//End AmvHelpModel class tail


