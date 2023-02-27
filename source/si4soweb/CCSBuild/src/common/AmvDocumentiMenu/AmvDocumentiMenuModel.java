//AmvDocumentiMenuModel imports @1-7DED2D05
package common.AmvDocumentiMenu;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocumentiMenuModel imports

//AmvDocumentiMenuModel class head @1-AA6C615A
public class AmvDocumentiMenuModel extends com.codecharge.components.Page {
    public AmvDocumentiMenuModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocumentiMenuModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocumentiMenuModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocumentiMenuModel class head

//page settings @1-D6931AA2
        super("AmvDocumentiMenu", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AmvDocumentiMenuModel class tail @1-F5FC18C5
    }
}
//End AmvDocumentiMenuModel class tail

