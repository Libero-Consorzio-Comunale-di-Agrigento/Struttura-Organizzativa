//AmvIncludeServletModel imports @1-6A19321A
package common.AmvIncludeServlet;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvIncludeServletModel imports

//AmvIncludeServletModel class head @1-D8DB10D6
public class AmvIncludeServletModel extends com.codecharge.components.Page {
    public AmvIncludeServletModel() {
        this( new CCSLocale(), null );
    }

    public AmvIncludeServletModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvIncludeServletModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvIncludeServletModel class head

//page settings @1-1769438B
        super("AmvIncludeServlet", locale );
        setResponse(response);
        {

            com.codecharge.components.Label Label1__2 = new com.codecharge.components.Label("Label1", "", this );
            Label1__2.setType( com.codecharge.components.ControlType.TEXT );
            Label1__2.setHtmlEncode( true );
            Label1__2.addControlListener( new AmvIncludeServletLabel1Handler());
            add( Label1__2 );
        } // end page
//End page settings

//AmvIncludeServletModel class tail @1-F5FC18C5
    }
}
//End AmvIncludeServletModel class tail

