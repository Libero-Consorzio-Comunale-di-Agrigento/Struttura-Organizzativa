//AmvRegistrazioneInizioModel imports @1-2E6468A3
package common.AmvRegistrazioneInizio;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRegistrazioneInizioModel imports

//AmvRegistrazioneInizioModel class head @1-A58D999B
public class AmvRegistrazioneInizioModel extends com.codecharge.components.Page {
    public AmvRegistrazioneInizioModel() {
        this( new CCSLocale(), null );
    }

    public AmvRegistrazioneInizioModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRegistrazioneInizioModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRegistrazioneInizioModel class head

//page settings @1-B1B80D7C
        super("AmvRegistrazioneInizio", locale );
        setResponse(response);
        addPageListener(new AmvRegistrazioneInizioPageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__109 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__109.setVisible( true );
            add( AmvGuida__109 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//PRIVACY grid @114-0EFD43B6
        
        /*
            // Begin definition of PRIVACY grid model.
        */
        {
            com.codecharge.components.Grid PRIVACY = new com.codecharge.components.Grid("PRIVACY");
            PRIVACY.setPageModel( this );
            PRIVACY.setFetchSize(20);
            PRIVACY.setVisible( true );

            com.codecharge.components.Label PRIVACY__115 = new com.codecharge.components.Label("PRIVACY", "PRIVACY", this );
            PRIVACY__115.setType( com.codecharge.components.ControlType.TEXT );
            PRIVACY.add(PRIVACY__115);
            add(PRIVACY);
        } // End definition of PRIVACY grid model
//End PRIVACY grid

//AD4_UTENTE record @50-2773B234
        
        /*
            Model of AD4_UTENTE record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTE = new com.codecharge.components.Record("AD4_UTENTE");
            AD4_UTENTE.setPageModel( this );
            AD4_UTENTE.addExcludeParam( "ccsForm" );
            AD4_UTENTE.setVisible( true );
            AD4_UTENTE.setAllowUpdate(false);
            AD4_UTENTE.setAllowDelete(false);
            AD4_UTENTE.setAllowRead(false);
            AD4_UTENTE.setPreserveType(PreserveParameterType.NONE);
            AD4_UTENTE.setReturnPage("AmvRegistrazioneInizio" + Names.ACTION_SUFFIX);
            AD4_UTENTE.addRecordListener(new AD4_UTENTERecordHandler());

            com.codecharge.components.TextBox NOMINATIVO__56 = new com.codecharge.components.TextBox("NOMINATIVO", "", this );
            NOMINATIVO__56.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__56.setHtmlEncode( true );
            NOMINATIVO__56.setCaption( "NOMINATIVO" );
            AD4_UTENTE.add( NOMINATIVO__56 );

            com.codecharge.components.TextBox COGNOME__57 = new com.codecharge.components.TextBox("COGNOME", "", this );
            COGNOME__57.setType( com.codecharge.components.ControlType.TEXT );
            COGNOME__57.setHtmlEncode( true );
            COGNOME__57.setCaption( "COGNOME" );
            AD4_UTENTE.add( COGNOME__57 );

            com.codecharge.components.TextBox NOME__58 = new com.codecharge.components.TextBox("NOME", "", this );
            NOME__58.setType( com.codecharge.components.ControlType.TEXT );
            NOME__58.setHtmlEncode( true );
            NOME__58.setCaption( "NOME" );
            AD4_UTENTE.add( NOME__58 );

            com.codecharge.components.ListBox SESSO__59 = new com.codecharge.components.ListBox("SESSO", "", this );
            SESSO__59.setType( com.codecharge.components.ControlType.TEXT );
            SESSO__59.setHtmlEncode( true );
            SESSO__59.setCaption( "SESSO" );
            AD4_UTENTE.add( SESSO__59 );

            com.codecharge.components.TextBox DATA_NASCITA__60 = new com.codecharge.components.TextBox("DATA_NASCITA", "", this );
            DATA_NASCITA__60.setType( com.codecharge.components.ControlType.DATE );
            DATA_NASCITA__60.setHtmlEncode( true );
            DATA_NASCITA__60.setFormatPattern( "dd/MM/yyyy" );
            DATA_NASCITA__60.setCaption( "DATA_NASCITA" );
            AD4_UTENTE.add( DATA_NASCITA__60 );

            com.codecharge.components.ListBox STATO_NASCITA__73 = new com.codecharge.components.ListBox("STATO_NASCITA", "", this );
            STATO_NASCITA__73.setType( com.codecharge.components.ControlType.INTEGER );
            STATO_NASCITA__73.setHtmlEncode( true );
            STATO_NASCITA__73.setCaption( "STATO_NASCITA" );
            STATO_NASCITA__73.setBoundColumn( "STATO_TERRITORIO" );
            STATO_NASCITA__73.setTextColumn( "DENOMINAZIONE" );
            AD4_UTENTE.add( STATO_NASCITA__73 );

            com.codecharge.components.ListBox PROVINCIA_NASCITA__61 = new com.codecharge.components.ListBox("PROVINCIA_NASCITA", "", this );
            PROVINCIA_NASCITA__61.setType( com.codecharge.components.ControlType.INTEGER );
            PROVINCIA_NASCITA__61.setHtmlEncode( true );
            PROVINCIA_NASCITA__61.setCaption( "PROVINCIA_NASCITA" );
            PROVINCIA_NASCITA__61.setBoundColumn( "PROVINCIA" );
            PROVINCIA_NASCITA__61.setTextColumn( "DENOMINAZIONE" );
            AD4_UTENTE.add( PROVINCIA_NASCITA__61 );

            com.codecharge.components.ListBox COMUNE_NASCITA__62 = new com.codecharge.components.ListBox("COMUNE_NASCITA", "", this );
            COMUNE_NASCITA__62.setType( com.codecharge.components.ControlType.INTEGER );
            COMUNE_NASCITA__62.setHtmlEncode( true );
            COMUNE_NASCITA__62.setCaption( "COMUNE_NASCITA" );
            COMUNE_NASCITA__62.setBoundColumn( "COMUNE" );
            COMUNE_NASCITA__62.setTextColumn( "DENOMINAZIONE" );
            AD4_UTENTE.add( COMUNE_NASCITA__62 );

            com.codecharge.components.TextBox CODICE_FISCALE__63 = new com.codecharge.components.TextBox("CODICE_FISCALE", "", this );
            CODICE_FISCALE__63.setType( com.codecharge.components.ControlType.TEXT );
            CODICE_FISCALE__63.setHtmlEncode( true );
            CODICE_FISCALE__63.setCaption( "CODICE_FISCALE" );
            AD4_UTENTE.add( CODICE_FISCALE__63 );

            com.codecharge.components.Button Update__113 = new com.codecharge.components.Button("Update", this);
            Update__113.addExcludeParam( "ccsForm" );
            Update__113.addExcludeParam( "Update" );
            Update__113.setOperation( "Update" );
            AD4_UTENTE.add( Update__113 );

            com.codecharge.components.Button Insert__53 = new com.codecharge.components.Button("Insert", this);
            Insert__53.addExcludeParam( "ccsForm" );
            Insert__53.addExcludeParam( "Insert" );
            Insert__53.setOperation( "Insert" );
            AD4_UTENTE.add( Insert__53 );

            com.codecharge.components.Hidden RR__110 = new com.codecharge.components.Hidden("RR", "", this );
            RR__110.setType( com.codecharge.components.ControlType.TEXT );
            RR__110.setHtmlEncode( true );
            RR__110.setCaption( "Rimuovi Richiesta" );
            AD4_UTENTE.add( RR__110 );
            add(AD4_UTENTE);
        } // End definition of AD4_UTENTE record model.
//End AD4_UTENTE record

//AmvRegistrazioneInizioModel class tail @1-F5FC18C5
    }
}
//End AmvRegistrazioneInizioModel class tail

