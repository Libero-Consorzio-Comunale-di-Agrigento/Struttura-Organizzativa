//LeftModel imports @1-B577A25E
package common.Left;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End LeftModel imports

//LeftModel class head @1-B0FC9D7B
public class LeftModel extends com.codecharge.components.Page {
    public LeftModel() {
        this( new CCSLocale(), null );
    }

    public LeftModel(CCSLocale locale) {
        this( locale, null );
    }

    public LeftModel( CCSLocale locale, HttpServletResponse response ) {
//End LeftModel class head

//page settings @1-C6630945
        super("Left", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvLeftMenu__2 = new com.codecharge.components.IncludePage("AmvLeftMenu", this );
            AmvLeftMenu__2.setVisible( true );
            add( AmvLeftMenu__2 );
            com.codecharge.components.IncludePage AmvLeftMenuSezioni__4 = new com.codecharge.components.IncludePage("AmvLeftMenuSezioni", this );
            AmvLeftMenuSezioni__4.setVisible( true );
            add( AmvLeftMenuSezioni__4 );
            com.codecharge.components.IncludePage AmvLeftDoc__3 = new com.codecharge.components.IncludePage("AmvLeftDoc", this );
            AmvLeftDoc__3.setVisible( true );
            add( AmvLeftDoc__3 );
        } // end page
//End page settings

//LeftModel class tail @1-F5FC18C5
    }
}
//End LeftModel class tail

