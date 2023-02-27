//AmvStyleModel imports @1-6E7F74C5
package common.AmvStyle;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvStyleModel imports

//AmvStyleModel class head @1-95F1C037
public class AmvStyleModel extends com.codecharge.components.Page {
    public AmvStyleModel() {
        this( new CCSLocale(), null );
    }

    public AmvStyleModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvStyleModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvStyleModel class head

//page settings @1-250D1605
        super("AmvStyle", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//style grid @2-33AFADEA
        
        /*
            // Begin definition of style grid model.
        */
        {
            com.codecharge.components.Grid style = new com.codecharge.components.Grid("style");
            style.setPageModel( this );
            style.setFetchSize(20);
            style.setVisible( true );

            com.codecharge.components.Label STILE__4 = new com.codecharge.components.Label("STILE", "STILE", this );
            STILE__4.setType( com.codecharge.components.ControlType.TEXT );
            style.add(STILE__4);
            add(style);
        } // End definition of style grid model
//End style grid

//AmvStyleModel class tail @1-F5FC18C5
    }
}
//End AmvStyleModel class tail

