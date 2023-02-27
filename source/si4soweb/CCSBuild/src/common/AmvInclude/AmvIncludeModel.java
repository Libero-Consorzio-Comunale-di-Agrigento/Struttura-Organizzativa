//AmvIncludeModel imports @1-8A1139F8
package common.AmvInclude;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvIncludeModel imports

//AmvIncludeModel class head @1-21C9E8DF
public class AmvIncludeModel extends com.codecharge.components.Page {
    public AmvIncludeModel() {
        this( new CCSLocale(), null );
    }

    public AmvIncludeModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvIncludeModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvIncludeModel class head

//page settings @1-D3E5C6F6
        super("AmvInclude", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage Pagina__2 = new com.codecharge.components.IncludePage("Pagina", this );
            Pagina__2.setVisible( true );
            add( Pagina__2 );
        } // end page
//End page settings

//AmvIncludeModel class tail @1-F5FC18C5
    }
}
//End AmvIncludeModel class tail

