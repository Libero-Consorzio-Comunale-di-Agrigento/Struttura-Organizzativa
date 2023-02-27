//RightModel imports @1-A221D0DB
package common.Right;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End RightModel imports

//RightModel class head @1-61E9B94D
public class RightModel extends com.codecharge.components.Page {
    public RightModel() {
        this( new CCSLocale(), null );
    }

    public RightModel(CCSLocale locale) {
        this( locale, null );
    }

    public RightModel( CCSLocale locale, HttpServletResponse response ) {
//End RightModel class head

//page settings @1-17102165
        super("Right", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvRightMenuSezioni__4 = new com.codecharge.components.IncludePage("AmvRightMenuSezioni", this );
            AmvRightMenuSezioni__4.setVisible( true );
            add( AmvRightMenuSezioni__4 );
            com.codecharge.components.IncludePage AmvRightDoc__3 = new com.codecharge.components.IncludePage("AmvRightDoc", this );
            AmvRightDoc__3.setVisible( true );
            add( AmvRightDoc__3 );
        } // end page
//End page settings

//RightModel class tail @1-F5FC18C5
    }
}
//End RightModel class tail


