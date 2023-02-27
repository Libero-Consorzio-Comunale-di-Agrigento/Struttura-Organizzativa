//ServletModulisticaModel imports @1-45A08561
package restrict.ServletModulistica;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End ServletModulisticaModel imports

//ServletModulisticaModel class head @1-F8A53EA7
public class ServletModulisticaModel extends com.codecharge.components.Page {
    public ServletModulisticaModel() {
        this( new CCSLocale(), null );
    }

    public ServletModulisticaModel(CCSLocale locale) {
        this( locale, null );
    }

    public ServletModulisticaModel( CCSLocale locale, HttpServletResponse response ) {
//End ServletModulisticaModel class head

//page settings @1-179714B5
        super("ServletModulistica", locale );
        setResponse(response);
        addPageListener(new ServletModulisticaPageHandler());
        {
            com.codecharge.components.IncludePage Header__52 = new com.codecharge.components.IncludePage("Header", this );
            Header__52.setVisible( true );
            add( Header__52 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );

            com.codecharge.components.Label corpoHtml__83 = new com.codecharge.components.Label("corpoHtml", "", this );
            corpoHtml__83.setType( com.codecharge.components.ControlType.TEXT );
            add( corpoHtml__83 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VISTA_DOCUMENTI grid @9-16CD09DA
        
        /*
            // Begin definition of AMV_VISTA_DOCUMENTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_VISTA_DOCUMENTI = new com.codecharge.components.Grid("AMV_VISTA_DOCUMENTI");
            AMV_VISTA_DOCUMENTI.setPageModel( this );
            AMV_VISTA_DOCUMENTI.setFetchSize(10);
            AMV_VISTA_DOCUMENTI.setVisible( true );

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(TITOLO__10);

            com.codecharge.components.Label MODIFICA__16 = new com.codecharge.components.Label("MODIFICA", "MOD_SRC", this );
            MODIFICA__16.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(MODIFICA__16);

            com.codecharge.components.Label STATO__53 = new com.codecharge.components.Label("STATO", "STATO", this );
            STATO__53.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(STATO__53);

            com.codecharge.components.Label COD_STATO__87 = new com.codecharge.components.Label("COD_STATO", "COD_STATO", this );
            COD_STATO__87.setType( com.codecharge.components.ControlType.TEXT );
            COD_STATO__87.setHtmlEncode( true );
            COD_STATO__87.addControlListener( new AMV_VISTA_DOCUMENTICOD_STATOHandler());
            AMV_VISTA_DOCUMENTI.add(COD_STATO__87);

            com.codecharge.components.Label DATA_ULTIMA_MODIFICA__21 = new com.codecharge.components.Label("DATA_ULTIMA_MODIFICA", "DATA_AGGIORNAMENTO", this );
            DATA_ULTIMA_MODIFICA__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_ULTIMA_MODIFICA__21.setHtmlEncode( true );
            DATA_ULTIMA_MODIFICA__21.setFormatPattern( "dd/MM/yyyy" );
            AMV_VISTA_DOCUMENTI.add(DATA_ULTIMA_MODIFICA__21);

            com.codecharge.components.Label TESTO__22 = new com.codecharge.components.Label("TESTO", "TESTO", this );
            TESTO__22.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(TESTO__22);

            com.codecharge.components.Label ALLEGATI__23 = new com.codecharge.components.Label("ALLEGATI", "ALLEGATI", this );
            ALLEGATI__23.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(ALLEGATI__23);
            add(AMV_VISTA_DOCUMENTI);
        } // End definition of AMV_VISTA_DOCUMENTI grid model
//End AMV_VISTA_DOCUMENTI grid

//INSERISCI_RICHIESTA grid @29-7EA190F4
        
        /*
            // Begin definition of INSERISCI_RICHIESTA grid model.
        */
        {
            com.codecharge.components.Grid INSERISCI_RICHIESTA = new com.codecharge.components.Grid("INSERISCI_RICHIESTA");
            INSERISCI_RICHIESTA.setPageModel( this );
            INSERISCI_RICHIESTA.setFetchSize(300);
            INSERISCI_RICHIESTA.setVisible( true );

            com.codecharge.components.Label MESSAGGIO__30 = new com.codecharge.components.Label("MESSAGGIO", "MSG", this );
            MESSAGGIO__30.setType( com.codecharge.components.ControlType.TEXT );
            MESSAGGIO__30.addControlListener( new INSERISCI_RICHIESTAMESSAGGIOHandler());
            INSERISCI_RICHIESTA.add(MESSAGGIO__30);
            add(INSERISCI_RICHIESTA);
        } // End definition of INSERISCI_RICHIESTA grid model
//End INSERISCI_RICHIESTA grid

//ServletModulisticaModel class tail @1-F5FC18C5
    }
}
//End ServletModulisticaModel class tail
