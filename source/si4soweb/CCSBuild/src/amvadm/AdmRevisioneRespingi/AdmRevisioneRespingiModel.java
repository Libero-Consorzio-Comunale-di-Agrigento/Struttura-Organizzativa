//AdmRevisioneRespingiModel imports @1-67AE6742
package amvadm.AdmRevisioneRespingi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioneRespingiModel imports

//AdmRevisioneRespingiModel class head @1-D2EAE4B8
public class AdmRevisioneRespingiModel extends com.codecharge.components.Page {
    public AdmRevisioneRespingiModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioneRespingiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioneRespingiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioneRespingiModel class head

//page settings @1-533834B9
        super("AdmRevisioneRespingi", locale );
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

//AMV_DOCUMENTO_RESPINGI record @6-A800FF21
        
        /*
            Model of AMV_DOCUMENTO_RESPINGI record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTO_RESPINGI = new com.codecharge.components.Record("AMV_DOCUMENTO_RESPINGI");
            AMV_DOCUMENTO_RESPINGI.setPageModel( this );
            AMV_DOCUMENTO_RESPINGI.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTO_RESPINGI.setVisible( true );
            AMV_DOCUMENTO_RESPINGI.setAllowInsert(false);
            AMV_DOCUMENTO_RESPINGI.setPreserveType(PreserveParameterType.GET);
            AMV_DOCUMENTO_RESPINGI.setReturnPage("AdmRevisioneRespingi" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTO_RESPINGI.add(TITOLO__7);

            com.codecharge.components.Hidden MVPAGES__46 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__46.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__46.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add( MVPAGES__46 );

            com.codecharge.components.Label DATA_INSERIMENTO__39 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__39.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__39.setHtmlEncode( true );
            DATA_INSERIMENTO__39.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_RESPINGI.add(DATA_INSERIMENTO__39);

            com.codecharge.components.Label NOMINATIVO_AUTORE__40 = new com.codecharge.components.Label("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE", this );
            NOMINATIVO_AUTORE__40.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AUTORE__40.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add(NOMINATIVO_AUTORE__40);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__21 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__21.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_RESPINGI.add(DATA_AGGIORNAMENTO__21);

            com.codecharge.components.Label NOMINATIVO_AGGIORNAMENTO__22 = new com.codecharge.components.Label("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO", this );
            NOMINATIVO_AGGIORNAMENTO__22.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AGGIORNAMENTO__22.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add(NOMINATIVO_AGGIORNAMENTO__22);

            com.codecharge.components.ListBox UTENTE_REDAZIONE__33 = new com.codecharge.components.ListBox("UTENTE_REDAZIONE", "UTENTE_REDAZIONE", this );
            UTENTE_REDAZIONE__33.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE_REDAZIONE__33.setHtmlEncode( true );
            UTENTE_REDAZIONE__33.setCaption( "UTENTE_REDAZIONE" );
            UTENTE_REDAZIONE__33.setBoundColumn( "UTENTE" );
            UTENTE_REDAZIONE__33.setTextColumn( "NOMINATIVO" );
            UTENTE_REDAZIONE__33.addValidateHandler( new RequiredHandler( "Il valore nel campo UTENTE_REDAZIONE è richiesto." ) );
            AMV_DOCUMENTO_RESPINGI.add( UTENTE_REDAZIONE__33 );

            com.codecharge.components.Hidden TIPO_TESTO__42 = new com.codecharge.components.Hidden("TIPO_TESTO", "TIPO_TESTO", this );
            TIPO_TESTO__42.setType( com.codecharge.components.ControlType.TEXT );
            TIPO_TESTO__42.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add( TIPO_TESTO__42 );

            com.codecharge.components.Hidden INOLTRO__43 = new com.codecharge.components.Hidden("INOLTRO", "INOLTRO", this );
            INOLTRO__43.setType( com.codecharge.components.ControlType.TEXT );
            INOLTRO__43.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add( INOLTRO__43 );

            com.codecharge.components.TextArea NOTE__32 = new com.codecharge.components.TextArea("NOTE", "", this );
            NOTE__32.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__32.setHtmlEncode( true );
            NOTE__32.setCaption( "NOTE" );
            AMV_DOCUMENTO_RESPINGI.add( NOTE__32 );

            com.codecharge.components.Label CRONOLOGIA__31 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__31.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__31.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add(CRONOLOGIA__31);

            com.codecharge.components.Label NOTE_LABEL__38 = new com.codecharge.components.Label("NOTE_LABEL", "NOTE", this );
            NOTE_LABEL__38.setType( com.codecharge.components.ControlType.TEXT );
            NOTE_LABEL__38.setHtmlEncode( true );
            AMV_DOCUMENTO_RESPINGI.add(NOTE_LABEL__38);

            com.codecharge.components.Button Update__11 = new com.codecharge.components.Button("Update", this);
            Update__11.addButtonListener(new AMV_DOCUMENTO_RESPINGIUpdateHandler());
            Update__11.addExcludeParam( "ccsForm" );
            Update__11.addExcludeParam( "Update" );
            Update__11.setOperation( "Update" );
            AMV_DOCUMENTO_RESPINGI.add( Update__11 );

            com.codecharge.components.Button Delete__41 = new com.codecharge.components.Button("Delete", this);
            Delete__41.addExcludeParam( "ccsForm" );
            Delete__41.addExcludeParam( "Delete" );
            Delete__41.setOperation( "Delete" );
            AMV_DOCUMENTO_RESPINGI.add( Delete__41 );

            com.codecharge.components.Button Cancel__13 = new com.codecharge.components.Button("Cancel", this);
            Cancel__13.addExcludeParam( "ccsForm" );
            Cancel__13.addExcludeParam( "Cancel" );
            Cancel__13.setOperation( "Cancel" );
            AMV_DOCUMENTO_RESPINGI.add( Cancel__13 );

            com.codecharge.components.Hidden REVISIONE__23 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__23.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__23.setHtmlEncode( true );
            REVISIONE__23.setCaption( "REVISIONE" );
            AMV_DOCUMENTO_RESPINGI.add( REVISIONE__23 );

            com.codecharge.components.Hidden ID_DOCUMENTO__14 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__14.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__14.setHtmlEncode( true );
            ID_DOCUMENTO__14.setCaption( "ID_DOCUMENTO" );
            AMV_DOCUMENTO_RESPINGI.add( ID_DOCUMENTO__14 );
            add(AMV_DOCUMENTO_RESPINGI);
        } // End definition of AMV_DOCUMENTO_RESPINGI record model.
//End AMV_DOCUMENTO_RESPINGI record

//AdmRevisioneRespingiModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioneRespingiModel class tail
