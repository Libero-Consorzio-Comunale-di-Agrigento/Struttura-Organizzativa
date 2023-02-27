//AmvRichiestaEliminaModel imports @1-16C27ED2
package common.AmvRichiestaElimina;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRichiestaEliminaModel imports

//AmvRichiestaEliminaModel class head @1-42A64179
public class AmvRichiestaEliminaModel extends com.codecharge.components.Page {
    public AmvRichiestaEliminaModel() {
        this( new CCSLocale(), null );
    }

    public AmvRichiestaEliminaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRichiestaEliminaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRichiestaEliminaModel class head

//page settings @1-FD342F2F
        super("AmvRichiestaElimina", locale );
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

//AMV_DOCUMENTO_RESPINGI record @6-3B3CC015
        
        /*
            Model of AMV_DOCUMENTO_RESPINGI record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTO_RESPINGI = new com.codecharge.components.Record("AMV_DOCUMENTO_RESPINGI");
            AMV_DOCUMENTO_RESPINGI.setPageModel( this );
            AMV_DOCUMENTO_RESPINGI.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTO_RESPINGI.setVisible( true );
            AMV_DOCUMENTO_RESPINGI.setAllowInsert(false);
            AMV_DOCUMENTO_RESPINGI.setAllowUpdate(false);
            AMV_DOCUMENTO_RESPINGI.setPreserveType(PreserveParameterType.GET);
            AMV_DOCUMENTO_RESPINGI.setReturnPage("AmvRichiestaElimina" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTO_RESPINGI.add(TITOLO__7);

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

            com.codecharge.components.TextArea NOTE__32 = new com.codecharge.components.TextArea("NOTE", "NOTE", this );
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
            AMV_DOCUMENTO_RESPINGI.add(NOTE_LABEL__38);

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

//AmvRichiestaEliminaModel class tail @1-F5FC18C5
    }
}
//End AmvRichiestaEliminaModel class tail
