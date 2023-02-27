//AmvRichiestaInoltraModel imports @1-FE4B75DA
package common.AmvRichiestaInoltra;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRichiestaInoltraModel imports

//AmvRichiestaInoltraModel class head @1-2A60969D
public class AmvRichiestaInoltraModel extends com.codecharge.components.Page {
    public AmvRichiestaInoltraModel() {
        this( new CCSLocale(), null );
    }

    public AmvRichiestaInoltraModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRichiestaInoltraModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRichiestaInoltraModel class head

//page settings @1-5A8AC60E
        super("AmvRichiestaInoltra", locale );
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

//RICHIESTA_INOLTRA record @6-4734F0EE
        
        /*
            Model of RICHIESTA_INOLTRA record defining.
        */
        {
            com.codecharge.components.Record RICHIESTA_INOLTRA = new com.codecharge.components.Record("RICHIESTA_INOLTRA");
            RICHIESTA_INOLTRA.setPageModel( this );
            RICHIESTA_INOLTRA.addExcludeParam( "ccsForm" );
            RICHIESTA_INOLTRA.setVisible( true );
            RICHIESTA_INOLTRA.setAllowInsert(false);
            RICHIESTA_INOLTRA.setPreserveType(PreserveParameterType.GET);
            RICHIESTA_INOLTRA.setReturnPage("AmvRichiestaInoltra" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            RICHIESTA_INOLTRA.add(TITOLO__7);

            com.codecharge.components.Label DATA_INSERIMENTO__39 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__39.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__39.setHtmlEncode( true );
            DATA_INSERIMENTO__39.setFormatPattern( "dd/MM/yyyy" );
            RICHIESTA_INOLTRA.add(DATA_INSERIMENTO__39);

            com.codecharge.components.Label NOMINATIVO_AUTORE__40 = new com.codecharge.components.Label("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE", this );
            NOMINATIVO_AUTORE__40.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AUTORE__40.setHtmlEncode( true );
            RICHIESTA_INOLTRA.add(NOMINATIVO_AUTORE__40);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__21 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__21.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            RICHIESTA_INOLTRA.add(DATA_AGGIORNAMENTO__21);

            com.codecharge.components.Label NOMINATIVO_AGGIORNAMENTO__22 = new com.codecharge.components.Label("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO", this );
            NOMINATIVO_AGGIORNAMENTO__22.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AGGIORNAMENTO__22.setHtmlEncode( true );
            RICHIESTA_INOLTRA.add(NOMINATIVO_AGGIORNAMENTO__22);

            com.codecharge.components.TextArea NOTE__32 = new com.codecharge.components.TextArea("NOTE", "NOTE", this );
            NOTE__32.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__32.setHtmlEncode( true );
            NOTE__32.setCaption( "NOTE" );
            RICHIESTA_INOLTRA.add( NOTE__32 );

            com.codecharge.components.Label CRONOLOGIA__31 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__31.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__31.setHtmlEncode( true );
            RICHIESTA_INOLTRA.add(CRONOLOGIA__31);

            com.codecharge.components.Label NOTE_LABEL__38 = new com.codecharge.components.Label("NOTE_LABEL", "NOTE", this );
            NOTE_LABEL__38.setType( com.codecharge.components.ControlType.TEXT );
            NOTE_LABEL__38.setHtmlEncode( true );
            RICHIESTA_INOLTRA.add(NOTE_LABEL__38);

            com.codecharge.components.Button Update__41 = new com.codecharge.components.Button("Update", this);
            Update__41.addExcludeParam( "ccsForm" );
            Update__41.addExcludeParam( "Update" );
            Update__41.setOperation( "Update" );
            RICHIESTA_INOLTRA.add( Update__41 );

            com.codecharge.components.Button Cancel__13 = new com.codecharge.components.Button("Cancel", this);
            Cancel__13.addExcludeParam( "ccsForm" );
            Cancel__13.addExcludeParam( "Cancel" );
            Cancel__13.setOperation( "Cancel" );
            RICHIESTA_INOLTRA.add( Cancel__13 );

            com.codecharge.components.Hidden REVISIONE__23 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__23.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__23.setHtmlEncode( true );
            REVISIONE__23.setCaption( "REVISIONE" );
            RICHIESTA_INOLTRA.add( REVISIONE__23 );

            com.codecharge.components.Hidden ID_DOCUMENTO__14 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__14.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__14.setHtmlEncode( true );
            ID_DOCUMENTO__14.setCaption( "ID_DOCUMENTO" );
            RICHIESTA_INOLTRA.add( ID_DOCUMENTO__14 );

            com.codecharge.components.Hidden STATO_FUTURO__48 = new com.codecharge.components.Hidden("STATO_FUTURO", "STATO_FUTURO", this );
            STATO_FUTURO__48.setType( com.codecharge.components.ControlType.TEXT );
            STATO_FUTURO__48.setHtmlEncode( true );
            RICHIESTA_INOLTRA.add( STATO_FUTURO__48 );
            add(RICHIESTA_INOLTRA);
        } // End definition of RICHIESTA_INOLTRA record model.
//End RICHIESTA_INOLTRA record

//AmvRichiestaInoltraModel class tail @1-F5FC18C5
    }
}
//End AmvRichiestaInoltraModel class tail
