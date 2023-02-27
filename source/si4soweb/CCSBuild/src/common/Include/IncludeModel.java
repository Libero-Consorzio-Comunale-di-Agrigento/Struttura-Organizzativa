//IncludeModel imports @1-AEBEA51E
package common.Include;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End IncludeModel imports

//IncludeModel class head @1-0997418B
public class IncludeModel extends com.codecharge.components.Page {
    public IncludeModel() {
        this( new CCSLocale(), null );
    }

    public IncludeModel(CCSLocale locale) {
        this( locale, null );
    }

    public IncludeModel( CCSLocale locale, HttpServletResponse response ) {
//End IncludeModel class head

//page settings @1-AB95834C
        super("Include", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvInclude__2 = new com.codecharge.components.IncludePage("AmvInclude", this );
            AmvInclude__2.setVisible( true );
            add( AmvInclude__2 );
        } // end page
//End page settings

//IncludeModel class tail @1-F5FC18C5
    }
}
//End IncludeModel class tail

