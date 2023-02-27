//AmvStiliModel imports @1-6AAB61B0
package restrict.AmvStili;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvStiliModel imports

//AmvStiliModel class head @1-E41D2350
public class AmvStiliModel extends com.codecharge.components.Page {
    public AmvStiliModel() {
        this( new CCSLocale(), null );
    }

    public AmvStiliModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvStiliModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvStiliModel class head

//page settings @1-BE16795C
        super("AmvStili", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//style grid @3-99176E57
        
        /*
            // Begin definition of style grid model.
        */
        {
            com.codecharge.components.Grid style = new com.codecharge.components.Grid("style");
            style.setPageModel( this );
            style.setFetchSize(20);
            style.setVisible( true );
            style.addGridListener( new styleGridHandler() );

            com.codecharge.components.Label STILE__4 = new com.codecharge.components.Label("STILE", this);
            STILE__4.setType( com.codecharge.components.ControlType.TEXT );
            style.add(STILE__4);
            add(style);
        } // End definition of style grid model
//End style grid

//AmvStiliModel class tail @1-F5FC18C5
    }
}
//End AmvStiliModel class tail

