//AmvServiziModel imports @1-6429A763
package restrict.AmvServizi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziModel imports

//AmvServiziModel class head @1-C499C248
public class AmvServiziModel extends com.codecharge.components.Page {
    public AmvServiziModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziModel class head

//page settings @1-C82B8674
        super("AmvServizi", locale );
        setResponse(response);
        addPageListener(new AmvServiziPageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__5 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__5.setVisible( true );
            add( AmvGuida__5 );
            com.codecharge.components.IncludePage AmvServiziElenco_i__6 = new com.codecharge.components.IncludePage("AmvServiziElenco_i", this );
            AmvServiziElenco_i__6.setVisible( true );
            add( AmvServiziElenco_i__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvServiziModel class tail @1-F5FC18C5
    }
}
//End AmvServiziModel class tail

