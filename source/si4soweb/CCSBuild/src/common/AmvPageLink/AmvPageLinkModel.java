//AmvPageLinkModel imports @1-3BF0F1CD
package common.AmvPageLink;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvPageLinkModel imports

//AmvPageLinkModel class head @1-8216DEE1
public class AmvPageLinkModel extends com.codecharge.components.Page {
    public AmvPageLinkModel() {
        this( new CCSLocale(), null );
    }

    public AmvPageLinkModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvPageLinkModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvPageLinkModel class head

//page settings @1-23EA89EA
        super("AmvPageLink", locale );
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
            com.codecharge.components.IncludePage IncludeLink__6 = new com.codecharge.components.IncludePage("IncludeLink", this );
            IncludeLink__6.setVisible( true );
            add( IncludeLink__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvPageLinkModel class tail @1-F5FC18C5
    }
}
//End AmvPageLinkModel class tail

