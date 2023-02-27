//si4soModel imports @1-0410AEF1
package restrict.si4so;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End si4soModel imports

//si4soModel class head @1-03DBA8E5
public class si4soModel extends com.codecharge.components.Page {
    public si4soModel() {
        this( new CCSLocale(), null );
    }

    public si4soModel(CCSLocale locale) {
        this( locale, null );
    }

    public si4soModel( CCSLocale locale, HttpServletResponse response ) {
//End si4soModel class head

//page settings @1-8421E433
        super("si4so", locale );
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
            iframe_src__6.addControlListener( new si4soiframe_srcHandler());
            add( iframe_src__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//si4soModel class tail @1-F5FC18C5
    }
}
//End si4soModel class tail
