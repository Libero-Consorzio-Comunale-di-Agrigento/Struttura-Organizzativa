//AmvDocumentoInfoModel imports @1-964A6DA1
package common.AmvDocumentoInfo;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocumentoInfoModel imports

//AmvDocumentoInfoModel class head @1-11DB1ABC
public class AmvDocumentoInfoModel extends com.codecharge.components.Page {
    public AmvDocumentoInfoModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocumentoInfoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocumentoInfoModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocumentoInfoModel class head

//page settings @1-DEC32456
        super("AmvDocumentoInfo", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvNavigatore__48 = new com.codecharge.components.IncludePage("AmvNavigatore", this );
            AmvNavigatore__48.setVisible( true );
            add( AmvNavigatore__48 );
            com.codecharge.components.IncludePage Right__50 = new com.codecharge.components.IncludePage("Right", this );
            Right__50.setVisible( true );
            add( Right__50 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VISTA_DOCUMENTI grid @5-79E9464B
        
        /*
            // Begin definition of AMV_VISTA_DOCUMENTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_VISTA_DOCUMENTI = new com.codecharge.components.Grid("AMV_VISTA_DOCUMENTI");
            AMV_VISTA_DOCUMENTI.setPageModel( this );
            AMV_VISTA_DOCUMENTI.setFetchSize(10);
            AMV_VISTA_DOCUMENTI.setVisible( true );

            com.codecharge.components.Label TITOLO__23 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__23.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(TITOLO__23);

            com.codecharge.components.Label IMG_LINK__30 = new com.codecharge.components.Label("IMG_LINK", "IMG_LINK", this );
            IMG_LINK__30.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(IMG_LINK__30);

            com.codecharge.components.Label STORICO__46 = new com.codecharge.components.Label("STORICO", "STORICO_SRC", this );
            STORICO__46.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(STORICO__46);

            com.codecharge.components.Label REVISIONA__32 = new com.codecharge.components.Label("REVISIONA", "REV_SRC", this );
            REVISIONA__32.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(REVISIONA__32);

            com.codecharge.components.Label MODIFICA__24 = new com.codecharge.components.Label("MODIFICA", "MOD_SRC", this );
            MODIFICA__24.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(MODIFICA__24);

            com.codecharge.components.Label STATO__49 = new com.codecharge.components.Label("STATO", "STATO", this );
            STATO__49.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(STATO__49);

            com.codecharge.components.Label INIZIO_PUBBLICAZIONE__7 = new com.codecharge.components.Label("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE", this );
            INIZIO_PUBBLICAZIONE__7.setType( com.codecharge.components.ControlType.DATE );
            INIZIO_PUBBLICAZIONE__7.setFormatPattern( "dd/MM/yyyy" );
            AMV_VISTA_DOCUMENTI.add(INIZIO_PUBBLICAZIONE__7);

            com.codecharge.components.Label DSP_FINE_PUBBLICAZIONE__18 = new com.codecharge.components.Label("DSP_FINE_PUBBLICAZIONE", "DSP_FINE_PUBBLICAZIONE", this );
            DSP_FINE_PUBBLICAZIONE__18.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(DSP_FINE_PUBBLICAZIONE__18);

            com.codecharge.components.Label DATA_ULTIMA_MODIFICA__8 = new com.codecharge.components.Label("DATA_ULTIMA_MODIFICA", "DATA_AGGIORNAMENTO", this );
            DATA_ULTIMA_MODIFICA__8.setType( com.codecharge.components.ControlType.DATE );
            DATA_ULTIMA_MODIFICA__8.setHtmlEncode( true );
            DATA_ULTIMA_MODIFICA__8.setFormatPattern( "dd/MM/yyyy" );
            AMV_VISTA_DOCUMENTI.add(DATA_ULTIMA_MODIFICA__8);

            com.codecharge.components.Label TESTO__12 = new com.codecharge.components.Label("TESTO", "TESTO", this );
            TESTO__12.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(TESTO__12);
            add(AMV_VISTA_DOCUMENTI);
        } // End definition of AMV_VISTA_DOCUMENTI grid model
//End AMV_VISTA_DOCUMENTI grid

//AmvDocumentoInfoModel class tail @1-F5FC18C5
    }
}
//End AmvDocumentoInfoModel class tail

