//AmvRegistrazioneAziendaModel imports @1-F9704C76
package common.AmvRegistrazioneAzienda;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRegistrazioneAziendaModel imports

//AmvRegistrazioneAziendaModel class head @1-F7C64217
public class AmvRegistrazioneAziendaModel extends com.codecharge.components.Page {
    public AmvRegistrazioneAziendaModel() {
        this( new CCSLocale(), null );
    }

    public AmvRegistrazioneAziendaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRegistrazioneAziendaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRegistrazioneAziendaModel class head

//page settings @1-D8E15FBA
        super("AmvRegistrazioneAzienda", locale );
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
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTE record @14-8DEC467E
        
        /*
            Model of AD4_UTENTE record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTE = new com.codecharge.components.Record("AD4_UTENTE");
            AD4_UTENTE.setPageModel( this );
            AD4_UTENTE.addExcludeParam( "ccsForm" );
            AD4_UTENTE.setVisible( true );
            AD4_UTENTE.setAllowInsert(false);
            AD4_UTENTE.setAllowDelete(false);
            AD4_UTENTE.setPreserveType(PreserveParameterType.ALL);
            AD4_UTENTE.setReturnPage("AmvRegistrazioneAzienda" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOMINATIVO__15 = new com.codecharge.components.TextBox("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__15.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTE.add( NOMINATIVO__15 );

            com.codecharge.components.TextBox SERVIZIO__16 = new com.codecharge.components.TextBox("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__16.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__16.setHtmlEncode( true );
            AD4_UTENTE.add( SERVIZIO__16 );

            com.codecharge.components.TextBox RS_AZIENDA__51 = new com.codecharge.components.TextBox("RS_AZIENDA", "", this );
            RS_AZIENDA__51.setType( com.codecharge.components.ControlType.TEXT );
            RS_AZIENDA__51.setHtmlEncode( true );
            RS_AZIENDA__51.setCaption( "RAGIONE SOCIALE" );
            RS_AZIENDA__51.addValidateHandler( new RequiredHandler( "Il valore nel campo RAGIONE SOCIALE è richiesto." ) );
            AD4_UTENTE.add( RS_AZIENDA__51 );

            com.codecharge.components.TextBox CF_AZIENDA__18 = new com.codecharge.components.TextBox("CF_AZIENDA", "", this );
            CF_AZIENDA__18.setType( com.codecharge.components.ControlType.TEXT );
            CF_AZIENDA__18.setHtmlEncode( true );
            CF_AZIENDA__18.setCaption( "CODICE FISCALE" );
            AD4_UTENTE.add( CF_AZIENDA__18 );

            com.codecharge.components.Button Indietro__52 = new com.codecharge.components.Button("Indietro", this);
            Indietro__52.addExcludeParam( "ccsForm" );
            Indietro__52.addExcludeParam( "Indietro" );
            Indietro__52.addExcludeParam( "Update" );
            Indietro__52.setOperation( "Cancel" );
            AD4_UTENTE.add( Indietro__52 );

            com.codecharge.components.Button Update__23 = new com.codecharge.components.Button("Update", this);
            Update__23.addExcludeParam( "ccsForm" );
            Update__23.addExcludeParam( "Update" );
            Update__23.setOperation( "Update" );
            AD4_UTENTE.add( Update__23 );

            com.codecharge.components.Hidden MVPAGES__27 = new com.codecharge.components.Hidden("MVPAGES", "REDIRECTION", this );
            MVPAGES__27.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__27.setHtmlEncode( true );
            MVPAGES__27.setCaption( "MVPAGES" );
            AD4_UTENTE.add( MVPAGES__27 );
            add(AD4_UTENTE);
        } // End definition of AD4_UTENTE record model.
//End AD4_UTENTE record

//AmvRegistrazioneAziendaModel class tail @1-F5FC18C5
    }
}
//End AmvRegistrazioneAziendaModel class tail

