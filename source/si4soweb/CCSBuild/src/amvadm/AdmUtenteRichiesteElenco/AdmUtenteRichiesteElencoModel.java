//AdmUtenteRichiesteElencoModel imports @1-E5C60D6B
package amvadm.AdmUtenteRichiesteElenco;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtenteRichiesteElencoModel imports

//AdmUtenteRichiesteElencoModel class head @1-2848CF73
public class AdmUtenteRichiesteElencoModel extends com.codecharge.components.Page {
    public AdmUtenteRichiesteElencoModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtenteRichiesteElencoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtenteRichiesteElencoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtenteRichiesteElencoModel class head

//page settings @1-391D9B63
        super("AdmUtenteRichiesteElenco", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__58 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__58.setVisible( true );
            add( Guida__58 );
            com.codecharge.components.IncludePage AmvUtenteNominativo_i__60 = new com.codecharge.components.IncludePage("AmvUtenteNominativo_i", this );
            AmvUtenteNominativo_i__60.setVisible( true );
            add( AmvUtenteNominativo_i__60 );
            com.codecharge.components.IncludePage AmvServiziElenco_i__59 = new com.codecharge.components.IncludePage("AmvServiziElenco_i", this );
            AmvServiziElenco_i__59.setVisible( true );
            add( AmvServiziElenco_i__59 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AdmUtenteRichiesteElencoModel class tail @1-F5FC18C5
    }
}
//End AdmUtenteRichiesteElencoModel class tail


