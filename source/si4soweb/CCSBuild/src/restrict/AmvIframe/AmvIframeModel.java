//AmvIframeModel imports @1-8EC285D2
package restrict.AmvIframe;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvIframeModel imports

//AmvIframeModel class head @1-4DCF8247
public class AmvIframeModel extends com.codecharge.components.Page {
    public AmvIframeModel() {
        this( new CCSLocale(), null );
    }

    public AmvIframeModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvIframeModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvIframeModel class head

//page settings @1-E5153A6E
        super("AmvIframe", locale );
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

            com.codecharge.components.Label iframe_src__6 = new com.codecharge.components.Label("iframe_src", "", this );
            iframe_src__6.setType( com.codecharge.components.ControlType.TEXT );
            iframe_src__6.addControlListener( new AmvIframeiframe_srcHandler());
            add( iframe_src__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvIframeModel class tail @1-F5FC18C5
    }
}
//End AmvIframeModel class tail

