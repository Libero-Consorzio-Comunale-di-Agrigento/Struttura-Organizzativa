//AmvLeftSezioneModel imports @1-86688B97
package common.AmvLeftSezione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLeftSezioneModel imports

//AmvLeftSezioneModel class head @1-46DDF795
public class AmvLeftSezioneModel extends com.codecharge.components.Page {
    public AmvLeftSezioneModel() {
        this( new CCSLocale(), null );
    }

    public AmvLeftSezioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLeftSezioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLeftSezioneModel class head

//page settings @1-E1AA756C
        super("AmvLeftSezione", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//SEZIONI_S grid @72-ECEBE4F5
        
        /*
            // Begin definition of SEZIONI_S grid model.
        */
        {
            com.codecharge.components.Grid SEZIONI_S = new com.codecharge.components.Grid("SEZIONI_S");
            SEZIONI_S.setPageModel( this );
            SEZIONI_S.setFetchSize(20);
            SEZIONI_S.setVisible( true );

            com.codecharge.components.Label BLOCCO__73 = new com.codecharge.components.Label("BLOCCO", "BLOCCO", this );
            BLOCCO__73.setType( com.codecharge.components.ControlType.TEXT );
            SEZIONI_S.add(BLOCCO__73);
            add(SEZIONI_S);
        } // End definition of SEZIONI_S grid model
//End SEZIONI_S grid

//AmvLeftSezioneModel class tail @1-F5FC18C5
    }
}
//End AmvLeftSezioneModel class tail
