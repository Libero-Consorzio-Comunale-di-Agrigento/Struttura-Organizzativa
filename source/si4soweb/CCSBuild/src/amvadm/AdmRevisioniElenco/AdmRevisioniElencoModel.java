//AdmRevisioniElencoModel imports @1-7AD21C58
package amvadm.AdmRevisioniElenco;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioniElencoModel imports

//AdmRevisioniElencoModel class head @1-0B0C1B40
public class AdmRevisioniElencoModel extends com.codecharge.components.Page {
    public AdmRevisioniElencoModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioniElencoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioniElencoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioniElencoModel class head

//page settings @1-A9AA141C
        super("AdmRevisioniElenco", locale );
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
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//ELENCO_REVISIONI grid @6-6B9A77FA
        
        /*
            // Begin definition of ELENCO_REVISIONI grid model.
        */
        {
            com.codecharge.components.Grid ELENCO_REVISIONI = new com.codecharge.components.Grid("ELENCO_REVISIONI");
            ELENCO_REVISIONI.setPageModel( this );
            ELENCO_REVISIONI.setFetchSize(20);
            ELENCO_REVISIONI.setVisible( true );
            ELENCO_REVISIONI.addGridListener( new ELENCO_REVISIONIGridHandler() );

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(TITOLO__7);

            com.codecharge.components.Label REVISIONE__13 = new com.codecharge.components.Label("REVISIONE", "REVISIONE", this );
            REVISIONE__13.setType( com.codecharge.components.ControlType.TEXT );
            REVISIONE__13.setHtmlEncode( true );
            ELENCO_REVISIONI.add(REVISIONE__13);

            com.codecharge.components.Label CRONOLOGIA__14 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__14.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__14.setHtmlEncode( true );
            ELENCO_REVISIONI.add(CRONOLOGIA__14);

            com.codecharge.components.Label STATO_DOCUMENTO__11 = new com.codecharge.components.Label("STATO_DOCUMENTO", "STATO_DOCUMENTO", this );
            STATO_DOCUMENTO__11.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(STATO_DOCUMENTO__11);

            com.codecharge.components.Label AFCNavigator__15 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__15.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_REVISIONI.add(AFCNavigator__15);
            add(ELENCO_REVISIONI);
        } // End definition of ELENCO_REVISIONI grid model
//End ELENCO_REVISIONI grid

//AdmRevisioniElencoModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioniElencoModel class tail
