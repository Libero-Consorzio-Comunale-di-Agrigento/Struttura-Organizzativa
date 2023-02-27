//AdmUtenteAccessiModel imports @1-737EF5B9
package amvadm.AdmUtenteAccessi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtenteAccessiModel imports

//AdmUtenteAccessiModel class head @1-A2DAA1C7
public class AdmUtenteAccessiModel extends com.codecharge.components.Page {
    public AdmUtenteAccessiModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtenteAccessiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtenteAccessiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtenteAccessiModel class head

//page settings @1-45FBAE4A
        super("AdmUtenteAccessi", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__5 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__5.setVisible( true );
            add( AmvGuida__5 );
            com.codecharge.components.IncludePage AmvUtenteNominativo_i__41 = new com.codecharge.components.IncludePage("AmvUtenteNominativo_i", this );
            AmvUtenteNominativo_i__41.setVisible( true );
            add( AmvUtenteNominativo_i__41 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTI record @6-0A3AC822
        
        /*
            Model of AD4_UTENTI record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTI = new com.codecharge.components.Record("AD4_UTENTI");
            AD4_UTENTI.setPageModel( this );
            AD4_UTENTI.addExcludeParam( "ccsForm" );
            AD4_UTENTI.setVisible( true );
            AD4_UTENTI.setAllowInsert(false);
            AD4_UTENTI.setAllowUpdate(false);
            AD4_UTENTI.setAllowDelete(false);
            AD4_UTENTI.setPreserveType(PreserveParameterType.GET);
            AD4_UTENTI.setReturnPage("AdmUtenteAccessi" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label NOMINATIVO__8 = new com.codecharge.components.Label("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__8.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__8.setHtmlEncode( true );
            AD4_UTENTI.add(NOMINATIVO__8);

            com.codecharge.components.Label UTENTE__9 = new com.codecharge.components.Label("UTENTE", "UTENTE", this );
            UTENTE__9.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE__9.setHtmlEncode( true );
            AD4_UTENTI.add(UTENTE__9);

            com.codecharge.components.Label DSP_ID_UTENTE__37 = new com.codecharge.components.Label("DSP_ID_UTENTE", "DSP_ID_UTENTE", this );
            DSP_ID_UTENTE__37.setType( com.codecharge.components.ControlType.TEXT );
            DSP_ID_UTENTE__37.setHtmlEncode( true );
            AD4_UTENTI.add(DSP_ID_UTENTE__37);

            com.codecharge.components.Label ULTIMO_TENTATIVO__16 = new com.codecharge.components.Label("ULTIMO_TENTATIVO", "ULTIMO_TENTATIVO", this );
            ULTIMO_TENTATIVO__16.setType( com.codecharge.components.ControlType.DATE );
            ULTIMO_TENTATIVO__16.setHtmlEncode( true );
            ULTIMO_TENTATIVO__16.setFormatPattern( "dd/MM/yyyy H:mm:ss" );
            AD4_UTENTI.add(ULTIMO_TENTATIVO__16);

            com.codecharge.components.Label DSP_NUMERO_TENTATIVI__36 = new com.codecharge.components.Label("DSP_NUMERO_TENTATIVI", "DSP_NUMERO_TENTATIVI", this );
            DSP_NUMERO_TENTATIVI__36.setType( com.codecharge.components.ControlType.TEXT );
            DSP_NUMERO_TENTATIVI__36.setHtmlEncode( true );
            AD4_UTENTI.add(DSP_NUMERO_TENTATIVI__36);

            com.codecharge.components.Label DATA_INSERIMENTO__38 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__38.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__38.setHtmlEncode( true );
            DATA_INSERIMENTO__38.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(DATA_INSERIMENTO__38);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__39 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__39.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__39.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__39.setFormatPattern( "dd/MM/yyyy" );
            AD4_UTENTI.add(DATA_AGGIORNAMENTO__39);

            com.codecharge.components.Label UTENTE_AGGIORNAMENTO__40 = new com.codecharge.components.Label("UTENTE_AGGIORNAMENTO", "UTENTE_AGGIORNAMENTO", this );
            UTENTE_AGGIORNAMENTO__40.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE_AGGIORNAMENTO__40.setHtmlEncode( true );
            AD4_UTENTI.add(UTENTE_AGGIORNAMENTO__40);
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI record model.
//End AD4_UTENTI record

//AD4_DIRITTI_ACCESSO grid @22-F042DBD7
        
        /*
            // Begin definition of AD4_DIRITTI_ACCESSO grid model.
        */
        {
            com.codecharge.components.Grid AD4_DIRITTI_ACCESSO = new com.codecharge.components.Grid("AD4_DIRITTI_ACCESSO");
            AD4_DIRITTI_ACCESSO.setPageModel( this );
            AD4_DIRITTI_ACCESSO.setFetchSize(10);
            AD4_DIRITTI_ACCESSO.setVisible( true );

            com.codecharge.components.Label DES_SERVIZIO__24 = new com.codecharge.components.Label("DES_SERVIZIO", "DES_SERVIZIO", this );
            DES_SERVIZIO__24.setType( com.codecharge.components.ControlType.TEXT );
            DES_SERVIZIO__24.setHtmlEncode( true );
            AD4_DIRITTI_ACCESSO.add(DES_SERVIZIO__24);

            com.codecharge.components.Label DSP_ACCESSO__29 = new com.codecharge.components.Label("DSP_ACCESSO", "DSP_ACCESSO", this );
            DSP_ACCESSO__29.setType( com.codecharge.components.ControlType.TEXT );
            AD4_DIRITTI_ACCESSO.add(DSP_ACCESSO__29);

            com.codecharge.components.Label DSP_NOTE__34 = new com.codecharge.components.Label("DSP_NOTE", "DSP_NOTE", this );
            DSP_NOTE__34.setType( com.codecharge.components.ControlType.TEXT );
            AD4_DIRITTI_ACCESSO.add(DSP_NOTE__34);
            add(AD4_DIRITTI_ACCESSO);
        } // End definition of AD4_DIRITTI_ACCESSO grid model
//End AD4_DIRITTI_ACCESSO grid

//AdmUtenteAccessiModel class tail @1-F5FC18C5
    }
}
//End AdmUtenteAccessiModel class tail


