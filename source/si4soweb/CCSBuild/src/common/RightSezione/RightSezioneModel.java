//RightSezioneModel imports @1-72B0ACC2
package common.RightSezione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End RightSezioneModel imports

//RightSezioneModel class head @1-7F81BD98
public class RightSezioneModel extends com.codecharge.components.Page {
    public RightSezioneModel() {
        this( new CCSLocale(), null );
    }

    public RightSezioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public RightSezioneModel( CCSLocale locale, HttpServletResponse response ) {
//End RightSezioneModel class head

//page settings @1-409B9843
        super("RightSezione", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvRightMenuSezioni__4 = new com.codecharge.components.IncludePage("AmvRightMenuSezioni", this );
            AmvRightMenuSezioni__4.setVisible( true );
            add( AmvRightMenuSezioni__4 );
            com.codecharge.components.IncludePage AmvRightDoc__5 = new com.codecharge.components.IncludePage("AmvRightDoc", this );
            AmvRightDoc__5.setVisible( true );
            add( AmvRightDoc__5 );
        } // end page
//End page settings

//RightSezioneModel class tail @1-F5FC18C5
    }
}
//End RightSezioneModel class tail
