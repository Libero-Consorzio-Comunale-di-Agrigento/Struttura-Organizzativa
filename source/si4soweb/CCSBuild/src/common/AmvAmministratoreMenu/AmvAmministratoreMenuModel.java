//AmvAmministratoreMenuModel imports @1-06237FC3
package common.AmvAmministratoreMenu;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvAmministratoreMenuModel imports

//AmvAmministratoreMenuModel class head @1-12C94503
public class AmvAmministratoreMenuModel extends com.codecharge.components.Page {
    public AmvAmministratoreMenuModel() {
        this( new CCSLocale(), null );
    }

    public AmvAmministratoreMenuModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvAmministratoreMenuModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvAmministratoreMenuModel class head

//page settings @1-D2FB6672
        super("AmvAmministratoreMenu", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AmvAmministratoreMenuModel class tail @1-F5FC18C5
    }
}
//End AmvAmministratoreMenuModel class tail


