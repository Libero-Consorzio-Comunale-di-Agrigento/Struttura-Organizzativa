//AmvVersioneModel imports @1-7FE4BB4F
package common.AmvVersione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvVersioneModel imports

//AmvVersioneModel class head @1-15B88734
public class AmvVersioneModel extends com.codecharge.components.Page {
    public AmvVersioneModel() {
        this( new CCSLocale(), null );
    }

    public AmvVersioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvVersioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvVersioneModel class head

//page settings @1-F798CBFF
        super("AmvVersione", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AmvVersioneModel class tail @1-F5FC18C5
    }
}
//End AmvVersioneModel class tail

