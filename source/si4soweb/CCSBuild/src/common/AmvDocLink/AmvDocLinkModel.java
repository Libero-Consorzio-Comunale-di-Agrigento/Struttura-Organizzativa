//AmvDocLinkModel imports @1-3C02364A
package common.AmvDocLink;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocLinkModel imports

//AmvDocLinkModel class head @1-A40C5718
public class AmvDocLinkModel extends com.codecharge.components.Page {
    public AmvDocLinkModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocLinkModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocLinkModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocLinkModel class head

//page settings @1-309D9A39
        super("AmvDocLink", locale );
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
            com.codecharge.components.IncludePage AmvIncludeDoc__6 = new com.codecharge.components.IncludePage("AmvIncludeDoc", this );
            AmvIncludeDoc__6.setVisible( true );
            add( AmvIncludeDoc__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvDocLinkModel class tail @1-F5FC18C5
    }
}
//End AmvDocLinkModel class tail




