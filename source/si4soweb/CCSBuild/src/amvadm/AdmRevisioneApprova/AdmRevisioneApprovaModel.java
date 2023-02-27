//AdmRevisioneApprovaModel imports @1-D8F38054
package amvadm.AdmRevisioneApprova;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioneApprovaModel imports

//AdmRevisioneApprovaModel class head @1-26ABCC2A
public class AdmRevisioneApprovaModel extends com.codecharge.components.Page {
    public AdmRevisioneApprovaModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioneApprovaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioneApprovaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioneApprovaModel class head

//page settings @1-11F5893C
        super("AdmRevisioneApprova", locale );
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

//AMV_DOCUMENTO_APPROVA record @6-05ACC7D6
        
        /*
            Model of AMV_DOCUMENTO_APPROVA record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTO_APPROVA = new com.codecharge.components.Record("AMV_DOCUMENTO_APPROVA");
            AMV_DOCUMENTO_APPROVA.setPageModel( this );
            AMV_DOCUMENTO_APPROVA.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTO_APPROVA.setVisible( true );
            AMV_DOCUMENTO_APPROVA.setAllowInsert(false);
            AMV_DOCUMENTO_APPROVA.setAllowDelete(false);
            AMV_DOCUMENTO_APPROVA.setPreserveType(PreserveParameterType.NONE);
            AMV_DOCUMENTO_APPROVA.setReturnPage("AdmRevisioneApprova" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTO_APPROVA.add(TITOLO__7);

            com.codecharge.components.Hidden MVPAGES__34 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__34.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__34.setHtmlEncode( true );
            AMV_DOCUMENTO_APPROVA.add( MVPAGES__34 );

            com.codecharge.components.Label DATA_INSERIMENTO__32 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__32.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__32.setHtmlEncode( true );
            DATA_INSERIMENTO__32.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_APPROVA.add(DATA_INSERIMENTO__32);

            com.codecharge.components.Label AUTORE__33 = new com.codecharge.components.Label("AUTORE", "AUTORE", this );
            AUTORE__33.setType( com.codecharge.components.ControlType.TEXT );
            AUTORE__33.setHtmlEncode( true );
            AMV_DOCUMENTO_APPROVA.add(AUTORE__33);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__21 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__21.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_APPROVA.add(DATA_AGGIORNAMENTO__21);

            com.codecharge.components.Label UTENTE_AGGIORNAMENTO__22 = new com.codecharge.components.Label("UTENTE_AGGIORNAMENTO", "UTENTE_AGGIORNAMENTO", this );
            UTENTE_AGGIORNAMENTO__22.setType( com.codecharge.components.ControlType.TEXT );
            UTENTE_AGGIORNAMENTO__22.setHtmlEncode( true );
            AMV_DOCUMENTO_APPROVA.add(UTENTE_AGGIORNAMENTO__22);

            com.codecharge.components.TextArea NOTE__30 = new com.codecharge.components.TextArea("NOTE", "", this );
            NOTE__30.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__30.setHtmlEncode( true );
            NOTE__30.setCaption( "NOTE" );
            AMV_DOCUMENTO_APPROVA.add( NOTE__30 );

            com.codecharge.components.Label CRONOLOGIA__26 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__26.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__26.setHtmlEncode( true );
            AMV_DOCUMENTO_APPROVA.add(CRONOLOGIA__26);

            com.codecharge.components.Label NOTE_LABEL__31 = new com.codecharge.components.Label("NOTE_LABEL", "NOTE", this );
            NOTE_LABEL__31.setType( com.codecharge.components.ControlType.TEXT );
            NOTE_LABEL__31.setHtmlEncode( true );
            AMV_DOCUMENTO_APPROVA.add(NOTE_LABEL__31);

            com.codecharge.components.Button Update__11 = new com.codecharge.components.Button("Update", this);
            Update__11.addExcludeParam( "ccsForm" );
            Update__11.addExcludeParam( "Update" );
            Update__11.setOperation( "Update" );
            AMV_DOCUMENTO_APPROVA.add( Update__11 );

            com.codecharge.components.Button Cancel__13 = new com.codecharge.components.Button("Cancel", this);
            Cancel__13.addExcludeParam( "ccsForm" );
            Cancel__13.addExcludeParam( "Cancel" );
            Cancel__13.setOperation( "Cancel" );
            AMV_DOCUMENTO_APPROVA.add( Cancel__13 );

            com.codecharge.components.Hidden REVISIONE__23 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__23.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__23.setHtmlEncode( true );
            REVISIONE__23.setCaption( "REVISIONE" );
            AMV_DOCUMENTO_APPROVA.add( REVISIONE__23 );

            com.codecharge.components.Hidden ID_DOCUMENTO__14 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__14.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__14.setHtmlEncode( true );
            ID_DOCUMENTO__14.setCaption( "ID_DOCUMENTO" );
            AMV_DOCUMENTO_APPROVA.add( ID_DOCUMENTO__14 );
            add(AMV_DOCUMENTO_APPROVA);
        } // End definition of AMV_DOCUMENTO_APPROVA record model.
//End AMV_DOCUMENTO_APPROVA record

//AdmRevisioneApprovaModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioneApprovaModel class tail
