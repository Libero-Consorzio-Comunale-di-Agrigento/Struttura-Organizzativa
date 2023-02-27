//AdmRevisioneRedazioneModel imports @1-8DA0FD7D
package amvadm.AdmRevisioneRedazione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioneRedazioneModel imports

//AdmRevisioneRedazioneModel class head @1-82A2DE06
public class AdmRevisioneRedazioneModel extends com.codecharge.components.Page {
    public AdmRevisioneRedazioneModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioneRedazioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioneRedazioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioneRedazioneModel class head

//page settings @1-1DD9BB69
        super("AdmRevisioneRedazione", locale );
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

//AMV_DOCUMENTO_REDAZIONE record @6-FE27F482
        
        /*
            Model of AMV_DOCUMENTO_REDAZIONE record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTO_REDAZIONE = new com.codecharge.components.Record("AMV_DOCUMENTO_REDAZIONE");
            AMV_DOCUMENTO_REDAZIONE.setPageModel( this );
            AMV_DOCUMENTO_REDAZIONE.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTO_REDAZIONE.setVisible( true );
            AMV_DOCUMENTO_REDAZIONE.setAllowInsert(false);
            AMV_DOCUMENTO_REDAZIONE.setAllowDelete(false);
            AMV_DOCUMENTO_REDAZIONE.setPreserveType(PreserveParameterType.GET);
            AMV_DOCUMENTO_REDAZIONE.setReturnPage("AdmRevisioneRedazione" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTO_REDAZIONE.add(TITOLO__7);

            com.codecharge.components.Hidden MVPAGES__36 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__36.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__36.setHtmlEncode( true );
            AMV_DOCUMENTO_REDAZIONE.add( MVPAGES__36 );

            com.codecharge.components.Label DATA_INSERIMENTO__34 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__34.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__34.setHtmlEncode( true );
            DATA_INSERIMENTO__34.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_REDAZIONE.add(DATA_INSERIMENTO__34);

            com.codecharge.components.Label NOMINATIVO_AUTORE__35 = new com.codecharge.components.Label("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE", this );
            NOMINATIVO_AUTORE__35.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AUTORE__35.setHtmlEncode( true );
            AMV_DOCUMENTO_REDAZIONE.add(NOMINATIVO_AUTORE__35);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__21 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__21.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_REDAZIONE.add(DATA_AGGIORNAMENTO__21);

            com.codecharge.components.Label NOMINATIVO_AGGIORNAMENTO__22 = new com.codecharge.components.Label("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO", this );
            NOMINATIVO_AGGIORNAMENTO__22.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AGGIORNAMENTO__22.setHtmlEncode( true );
            AMV_DOCUMENTO_REDAZIONE.add(NOMINATIVO_AGGIORNAMENTO__22);

            com.codecharge.components.ListBox VERIFICATORE__16 = new com.codecharge.components.ListBox("VERIFICATORE", "UTENTE_VERIFICA", this );
            VERIFICATORE__16.setType( com.codecharge.components.ControlType.TEXT );
            VERIFICATORE__16.setHtmlEncode( true );
            VERIFICATORE__16.setCaption( "VERIFICATORE" );
            VERIFICATORE__16.setBoundColumn( "UTENTE" );
            VERIFICATORE__16.setTextColumn( "NOMINATIVO" );
            VERIFICATORE__16.addValidateHandler( new RequiredHandler( "Il valore nel campo VERIFICATORE è richiesto." ) );
            AMV_DOCUMENTO_REDAZIONE.add( VERIFICATORE__16 );

            com.codecharge.components.TextArea NOTE__32 = new com.codecharge.components.TextArea("NOTE", "", this );
            NOTE__32.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__32.setHtmlEncode( true );
            NOTE__32.setCaption( "NOTE" );
            AMV_DOCUMENTO_REDAZIONE.add( NOTE__32 );

            com.codecharge.components.Label CRONOLOGIA__31 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__31.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__31.setHtmlEncode( true );
            AMV_DOCUMENTO_REDAZIONE.add(CRONOLOGIA__31);

            com.codecharge.components.Label NOTE_LABEL__33 = new com.codecharge.components.Label("NOTE_LABEL", "NOTE", this );
            NOTE_LABEL__33.setType( com.codecharge.components.ControlType.TEXT );
            NOTE_LABEL__33.setHtmlEncode( true );
            AMV_DOCUMENTO_REDAZIONE.add(NOTE_LABEL__33);

            com.codecharge.components.Button Update__11 = new com.codecharge.components.Button("Update", this);
            Update__11.addExcludeParam( "ccsForm" );
            Update__11.addExcludeParam( "Update" );
            Update__11.setOperation( "Update" );
            AMV_DOCUMENTO_REDAZIONE.add( Update__11 );

            com.codecharge.components.Button Cancel__13 = new com.codecharge.components.Button("Cancel", this);
            Cancel__13.addExcludeParam( "ccsForm" );
            Cancel__13.addExcludeParam( "Cancel" );
            Cancel__13.setOperation( "Cancel" );
            AMV_DOCUMENTO_REDAZIONE.add( Cancel__13 );

            com.codecharge.components.Hidden REVISIONE__23 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__23.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__23.setHtmlEncode( true );
            REVISIONE__23.setCaption( "REVISIONE" );
            AMV_DOCUMENTO_REDAZIONE.add( REVISIONE__23 );

            com.codecharge.components.Hidden ID_DOCUMENTO__14 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__14.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__14.setHtmlEncode( true );
            ID_DOCUMENTO__14.setCaption( "ID_DOCUMENTO" );
            AMV_DOCUMENTO_REDAZIONE.add( ID_DOCUMENTO__14 );
            add(AMV_DOCUMENTO_REDAZIONE);
        } // End definition of AMV_DOCUMENTO_REDAZIONE record model.
//End AMV_DOCUMENTO_REDAZIONE record

//AdmRevisioneRedazioneModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioneRedazioneModel class tail
