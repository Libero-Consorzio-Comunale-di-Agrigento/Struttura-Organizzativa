//AmvControlModel imports @1-CC5E5AC1
package common.AmvControl;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvControlModel imports

//AmvControlModel class head @1-29E01C4F
public class AmvControlModel extends com.codecharge.components.Page {
    public AmvControlModel() {
        this( new CCSLocale(), null );
    }

    public AmvControlModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvControlModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvControlModel class head

//page settings @1-7BDDBF70
        super("AmvControl", locale );
        setResponse(response);
        setIncluded(true);
        addPageListener(new AmvControlPageHandler());
        {
        } // end page
//End page settings

//AmvControlModel class tail @1-F5FC18C5
    }
}
//End AmvControlModel class tail

