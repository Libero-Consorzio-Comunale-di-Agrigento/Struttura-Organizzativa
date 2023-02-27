//IncludeLinkModel imports @1-840885AC
package common.IncludeLink;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End IncludeLinkModel imports

//IncludeLinkModel class head @1-EB5DC55F
public class IncludeLinkModel extends com.codecharge.components.Page {
    public IncludeLinkModel() {
        this( new CCSLocale(), null );
    }

    public IncludeLinkModel(CCSLocale locale) {
        this( locale, null );
    }

    public IncludeLinkModel( CCSLocale locale, HttpServletResponse response ) {
//End IncludeLinkModel class head

//page settings @1-AC46CFF4
        super("IncludeLink", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvIncludeLink__2 = new com.codecharge.components.IncludePage("AmvIncludeLink", this );
            AmvIncludeLink__2.setVisible( true );
            add( AmvIncludeLink__2 );
        } // end page
//End page settings

//IncludeLinkModel class tail @1-F5FC18C5
    }
}
//End IncludeLinkModel class tail

