//AmvAccessNoControlModel imports @1-B1C6C404
package common.AmvAccessNoControl;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAccessNoControlModel imports

//AmvAccessNoControlModel class head @1-06BEB106
public class AmvAccessNoControlModel extends com.codecharge.components.Page {
    public AmvAccessNoControlModel() {
        this( new CCSLocale(), null );
    }

    public AmvAccessNoControlModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAccessNoControlModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAccessNoControlModel class head

//page settings @1-1A977115
        super("AmvAccessNoControl", locale );
        setResponse(response);
        setIncluded(true);
        addPageListener(new AmvAccessNoControlPageHandler());
        {
        } // end page
//End page settings

//AmvAccessNoControlModel class tail @1-F5FC18C5
    }
}
//End AmvAccessNoControlModel class tail

