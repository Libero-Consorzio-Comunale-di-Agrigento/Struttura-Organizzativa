//AmvHomeModel imports @1-316CCEFE
package common.AmvHome;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvHomeModel imports

//AmvHomeModel class head @1-A7929440
public class AmvHomeModel extends com.codecharge.components.Page {
    public AmvHomeModel() {
        this( new CCSLocale(), null );
    }

    public AmvHomeModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvHomeModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvHomeModel class head

//page settings @1-B39A806C
        super("AmvHome", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//HOME_GRID grid @2-F91CC89D
        
        /*
            // Begin definition of HOME_GRID grid model.
        */
        {
            com.codecharge.components.Grid HOME_GRID = new com.codecharge.components.Grid("HOME_GRID");
            HOME_GRID.setPageModel( this );
            HOME_GRID.setFetchSize(20);
            HOME_GRID.setVisible( true );
            HOME_GRID.addGridListener( new HOME_GRIDGridHandler() );

            com.codecharge.components.Label HOME__3 = new com.codecharge.components.Label("HOME", "HOME", this );
            HOME__3.setType( com.codecharge.components.ControlType.TEXT );
            HOME_GRID.add(HOME__3);
            add(HOME_GRID);
        } // End definition of HOME_GRID grid model
//End HOME_GRID grid

//AmvHomeModel class tail @1-F5FC18C5
    }
}
//End AmvHomeModel class tail

