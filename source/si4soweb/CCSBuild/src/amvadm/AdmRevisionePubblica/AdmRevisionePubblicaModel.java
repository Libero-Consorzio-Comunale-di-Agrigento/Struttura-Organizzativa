//AdmRevisionePubblicaModel imports @1-F362B33C
package amvadm.AdmRevisionePubblica;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisionePubblicaModel imports

//AdmRevisionePubblicaModel class head @1-BA904BCA
public class AdmRevisionePubblicaModel extends com.codecharge.components.Page {
    public AdmRevisionePubblicaModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisionePubblicaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisionePubblicaModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisionePubblicaModel class head

//page settings @1-BE5558C8
        super("AdmRevisionePubblica", locale );
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

//AMV_DOCUMENTO_PUBBLICA record @6-F4DE2DC2
        
        /*
            Model of AMV_DOCUMENTO_PUBBLICA record defining.
        */
        {
            com.codecharge.components.Record AMV_DOCUMENTO_PUBBLICA = new com.codecharge.components.Record("AMV_DOCUMENTO_PUBBLICA");
            AMV_DOCUMENTO_PUBBLICA.setPageModel( this );
            AMV_DOCUMENTO_PUBBLICA.addExcludeParam( "ccsForm" );
            AMV_DOCUMENTO_PUBBLICA.setVisible( true );
            AMV_DOCUMENTO_PUBBLICA.setAllowInsert(false);
            AMV_DOCUMENTO_PUBBLICA.setAllowDelete(false);
            AMV_DOCUMENTO_PUBBLICA.setPreserveType(PreserveParameterType.GET);
            AMV_DOCUMENTO_PUBBLICA.setReturnPage("AdmRevisionePubblica" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label TITOLO__7 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__7.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DOCUMENTO_PUBBLICA.add(TITOLO__7);

            com.codecharge.components.Hidden MVPAGES__38 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__38.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__38.setHtmlEncode( true );
            AMV_DOCUMENTO_PUBBLICA.add( MVPAGES__38 );

            com.codecharge.components.Label DATA_INSERIMENTO__36 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__36.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__36.setHtmlEncode( true );
            DATA_INSERIMENTO__36.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_PUBBLICA.add(DATA_INSERIMENTO__36);

            com.codecharge.components.Label NOMINATIVO_AUTORE__37 = new com.codecharge.components.Label("NOMINATIVO_AUTORE", "NOMINATIVO_AUTORE", this );
            NOMINATIVO_AUTORE__37.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AUTORE__37.setHtmlEncode( true );
            AMV_DOCUMENTO_PUBBLICA.add(NOMINATIVO_AUTORE__37);

            com.codecharge.components.Label DATA_AGGIORNAMENTO__21 = new com.codecharge.components.Label("DATA_AGGIORNAMENTO", "DATA_AGGIORNAMENTO", this );
            DATA_AGGIORNAMENTO__21.setType( com.codecharge.components.ControlType.DATE );
            DATA_AGGIORNAMENTO__21.setHtmlEncode( true );
            DATA_AGGIORNAMENTO__21.setFormatPattern( "dd/MM/yyyy" );
            AMV_DOCUMENTO_PUBBLICA.add(DATA_AGGIORNAMENTO__21);

            com.codecharge.components.Label NOMINATIVO_AGGIORNAMENTO__22 = new com.codecharge.components.Label("NOMINATIVO_AGGIORNAMENTO", "NOMINATIVO_AGGIORNAMENTO", this );
            NOMINATIVO_AGGIORNAMENTO__22.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO_AGGIORNAMENTO__22.setHtmlEncode( true );
            AMV_DOCUMENTO_PUBBLICA.add(NOMINATIVO_AGGIORNAMENTO__22);

            com.codecharge.components.TextBox INIZIO_PUBBLICAZIONE__30 = new com.codecharge.components.TextBox("INIZIO_PUBBLICAZIONE", "INIZIO_PUBBLICAZIONE", this );
            INIZIO_PUBBLICAZIONE__30.setType( com.codecharge.components.ControlType.DATE );
            INIZIO_PUBBLICAZIONE__30.setHtmlEncode( true );
            INIZIO_PUBBLICAZIONE__30.setFormatPattern( "dd/MM/yyyy" );
            INIZIO_PUBBLICAZIONE__30.setCaption( "INIZIO PUBBLICAZIONE" );
            AMV_DOCUMENTO_PUBBLICA.add( INIZIO_PUBBLICAZIONE__30 );
            com.codecharge.components.DatePicker DatePicker1__32 = new com.codecharge.components.DatePicker("DatePicker1", this);
            DatePicker1__32.setControlName("INIZIO_PUBBLICAZIONE");
            DatePicker1__32.setStyleName("../Themes/AFC/Style.css");
            AMV_DOCUMENTO_PUBBLICA.add(DatePicker1__32);

            com.codecharge.components.TextBox FINE_PUBBLICAZIONE__31 = new com.codecharge.components.TextBox("FINE_PUBBLICAZIONE", "FINE_PUBBLICAZIONE", this );
            FINE_PUBBLICAZIONE__31.setType( com.codecharge.components.ControlType.DATE );
            FINE_PUBBLICAZIONE__31.setHtmlEncode( true );
            FINE_PUBBLICAZIONE__31.setFormatPattern( "dd/MM/yyyy" );
            FINE_PUBBLICAZIONE__31.setCaption( "FINE PUBBLICAZIONE" );
            AMV_DOCUMENTO_PUBBLICA.add( FINE_PUBBLICAZIONE__31 );
            com.codecharge.components.DatePicker DatePicker2__33 = new com.codecharge.components.DatePicker("DatePicker2", this);
            DatePicker2__33.setControlName("FINE_PUBBLICAZIONE");
            DatePicker2__33.setStyleName("../Themes/AFC/Style.css");
            AMV_DOCUMENTO_PUBBLICA.add(DatePicker2__33);

            com.codecharge.components.Label CRONOLOGIA__26 = new com.codecharge.components.Label("CRONOLOGIA", "CRONOLOGIA", this );
            CRONOLOGIA__26.setType( com.codecharge.components.ControlType.TEXT );
            CRONOLOGIA__26.setHtmlEncode( true );
            AMV_DOCUMENTO_PUBBLICA.add(CRONOLOGIA__26);

            com.codecharge.components.Label NOTE__34 = new com.codecharge.components.Label("NOTE", "NOTE", this );
            NOTE__34.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__34.setHtmlEncode( true );
            AMV_DOCUMENTO_PUBBLICA.add(NOTE__34);

            com.codecharge.components.Button Update__11 = new com.codecharge.components.Button("Update", this);
            Update__11.addExcludeParam( "ccsForm" );
            Update__11.addExcludeParam( "Update" );
            Update__11.setOperation( "Update" );
            AMV_DOCUMENTO_PUBBLICA.add( Update__11 );

            com.codecharge.components.Button Cancel__13 = new com.codecharge.components.Button("Cancel", this);
            Cancel__13.addExcludeParam( "ccsForm" );
            Cancel__13.addExcludeParam( "Cancel" );
            Cancel__13.setOperation( "Cancel" );
            AMV_DOCUMENTO_PUBBLICA.add( Cancel__13 );

            com.codecharge.components.Hidden REVISIONE__23 = new com.codecharge.components.Hidden("REVISIONE", "REVISIONE", this );
            REVISIONE__23.setType( com.codecharge.components.ControlType.INTEGER );
            REVISIONE__23.setHtmlEncode( true );
            REVISIONE__23.setCaption( "REVISIONE" );
            AMV_DOCUMENTO_PUBBLICA.add( REVISIONE__23 );

            com.codecharge.components.Hidden ID_DOCUMENTO__14 = new com.codecharge.components.Hidden("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__14.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DOCUMENTO__14.setHtmlEncode( true );
            ID_DOCUMENTO__14.setCaption( "ID_DOCUMENTO" );
            AMV_DOCUMENTO_PUBBLICA.add( ID_DOCUMENTO__14 );
            add(AMV_DOCUMENTO_PUBBLICA);
        } // End definition of AMV_DOCUMENTO_PUBBLICA record model.
//End AMV_DOCUMENTO_PUBBLICA record

//AdmRevisionePubblicaModel class tail @1-F5FC18C5
    }
}
//End AdmRevisionePubblicaModel class tail
