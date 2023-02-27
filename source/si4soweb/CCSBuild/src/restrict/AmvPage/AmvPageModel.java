//AmvPageModel imports @1-F44BC6A8
package restrict.AmvPage;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvPageModel imports

//AmvPageModel class head @1-F82117F9
public class AmvPageModel extends com.codecharge.components.Page {
    public AmvPageModel() {
        this( new CCSLocale(), null );
    }

    public AmvPageModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvPageModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvPageModel class head

//page settings @1-D5E01FE6
        super("AmvPage", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage AmvInclude__6 = new com.codecharge.components.IncludePage("AmvInclude", this );
            AmvInclude__6.setVisible( true );
            add( AmvInclude__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvPageModel class tail @1-F5FC18C5
    }
}
//End AmvPageModel class tail


