//indexModel imports @1-F32725FA
package restrict.index;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End indexModel imports

//indexModel class head @1-314FFF64
public class indexModel extends com.codecharge.components.Page {
    public indexModel() {
        this( new CCSLocale(), null );
    }

    public indexModel(CCSLocale locale) {
        this( locale, null );
    }

    public indexModel( CCSLocale locale, HttpServletResponse response ) {
//End indexModel class head

//page settings @1-B4C5A26F
        super("index", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//indexModel class tail @1-F5FC18C5
    }
}
//End indexModel class tail

