//FooterModel imports @1-FA17EC59
package common.Footer;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End FooterModel imports

//FooterModel class head @1-5134B5EB
public class FooterModel extends com.codecharge.components.Page {
    public FooterModel() {
        this( new CCSLocale(), null );
    }

    public FooterModel(CCSLocale locale) {
        this( locale, null );
    }

    public FooterModel( CCSLocale locale, HttpServletResponse response ) {
//End FooterModel class head

//page settings @1-B11DB448
        super("Footer", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvFooter__2 = new com.codecharge.components.IncludePage("AmvFooter", this );
            AmvFooter__2.setVisible( true );
            add( AmvFooter__2 );
        } // end page
//End page settings

//FooterModel class tail @1-F5FC18C5
    }
}
//End FooterModel class tail

