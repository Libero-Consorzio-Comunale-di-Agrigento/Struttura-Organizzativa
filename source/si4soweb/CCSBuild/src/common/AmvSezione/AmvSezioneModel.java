//AmvSezioneModel imports @1-AF92CB28
package common.AmvSezione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvSezioneModel imports

//AmvSezioneModel class head @1-87958056
public class AmvSezioneModel extends com.codecharge.components.Page {
    public AmvSezioneModel() {
        this( new CCSLocale(), null );
    }

    public AmvSezioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvSezioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvSezioneModel class head

//page settings @1-902F6DFD
        super("AmvSezione", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage LeftSezione__3 = new com.codecharge.components.IncludePage("LeftSezione", this );
            LeftSezione__3.setVisible( true );
            add( LeftSezione__3 );
            com.codecharge.components.IncludePage AmvNavigatore__46 = new com.codecharge.components.IncludePage("AmvNavigatore", this );
            AmvNavigatore__46.setVisible( true );
            add( AmvNavigatore__46 );
            com.codecharge.components.IncludePage AmvCenterMenuSezioni__48 = new com.codecharge.components.IncludePage("AmvCenterMenuSezioni", this );
            AmvCenterMenuSezioni__48.setVisible( true );
            add( AmvCenterMenuSezioni__48 );
            com.codecharge.components.IncludePage RightSezione__47 = new com.codecharge.components.IncludePage("RightSezione", this );
            RightSezione__47.setVisible( true );
            add( RightSezione__47 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvSezioneModel class tail @1-F5FC18C5
    }
}
//End AmvSezioneModel class tail
