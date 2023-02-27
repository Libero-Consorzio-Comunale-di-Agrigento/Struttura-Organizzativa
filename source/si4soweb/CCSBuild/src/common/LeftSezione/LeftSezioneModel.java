//LeftSezioneModel imports @1-94E99010
package common.LeftSezione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End LeftSezioneModel imports

//LeftSezioneModel class head @1-62FD506F
public class LeftSezioneModel extends com.codecharge.components.Page {
    public LeftSezioneModel() {
        this( new CCSLocale(), null );
    }

    public LeftSezioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public LeftSezioneModel( CCSLocale locale, HttpServletResponse response ) {
//End LeftSezioneModel class head

//page settings @1-FE845B5A
        super("LeftSezione", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvLeftMenu__2 = new com.codecharge.components.IncludePage("AmvLeftMenu", this );
            AmvLeftMenu__2.setVisible( true );
            add( AmvLeftMenu__2 );
            com.codecharge.components.IncludePage AmvLeftMenuSezioni__4 = new com.codecharge.components.IncludePage("AmvLeftMenuSezioni", this );
            AmvLeftMenuSezioni__4.setVisible( true );
            add( AmvLeftMenuSezioni__4 );
            com.codecharge.components.IncludePage AmvLeftDoc__5 = new com.codecharge.components.IncludePage("AmvLeftDoc", this );
            AmvLeftDoc__5.setVisible( true );
            add( AmvLeftDoc__5 );
        } // end page
//End page settings

//LeftSezioneModel class tail @1-F5FC18C5
    }
}
//End LeftSezioneModel class tail
