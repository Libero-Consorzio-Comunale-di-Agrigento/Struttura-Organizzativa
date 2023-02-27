//AmvLeftMenuModel imports @1-C26C87AA
package common.AmvLeftMenu;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLeftMenuModel imports

//AmvLeftMenuModel class head @1-C902ADA1
public class AmvLeftMenuModel extends com.codecharge.components.Page {
    public AmvLeftMenuModel() {
        this( new CCSLocale(), null );
    }

    public AmvLeftMenuModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLeftMenuModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLeftMenuModel class head

//page settings @1-16E5C350
        super("AmvLeftMenu", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Menu grid @103-46701ED4
        
        /*
            // Begin definition of Menu grid model.
        */
        {
            com.codecharge.components.Grid Menu = new com.codecharge.components.Grid("Menu");
            Menu.setPageModel( this );
            Menu.setFetchSize(20);
            Menu.setVisible( true );

            com.codecharge.components.Label MENU__104 = new com.codecharge.components.Label("MENU", "TABELLA", this );
            MENU__104.setType( com.codecharge.components.ControlType.TEXT );
            Menu.add(MENU__104);
            add(Menu);
        } // End definition of Menu grid model
//End Menu grid

//AmvLeftMenuModel class tail @1-F5FC18C5
    }
}
//End AmvLeftMenuModel class tail

