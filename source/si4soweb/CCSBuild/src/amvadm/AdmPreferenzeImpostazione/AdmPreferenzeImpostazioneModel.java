//AdmPreferenzeImpostazioneModel imports @1-AB03D846
package amvadm.AdmPreferenzeImpostazione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmPreferenzeImpostazioneModel imports

//AdmPreferenzeImpostazioneModel class head @1-7499CC68
public class AdmPreferenzeImpostazioneModel extends com.codecharge.components.Page {
    public AdmPreferenzeImpostazioneModel() {
        this( new CCSLocale(), null );
    }

    public AdmPreferenzeImpostazioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmPreferenzeImpostazioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmPreferenzeImpostazioneModel class head

//page settings @1-74D636AF
        super("AdmPreferenzeImpostazione", locale );
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

//TITLEGrid grid @31-372F41CE
        
        /*
            // Begin definition of TITLEGrid grid model.
        */
        {
            com.codecharge.components.Grid TITLEGrid = new com.codecharge.components.Grid("TITLEGrid");
            TITLEGrid.setPageModel( this );
            TITLEGrid.setFetchSize(20);
            TITLEGrid.setVisible( true );

            com.codecharge.components.Label TITOLO__32 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__32.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__32.setHtmlEncode( true );
            TITLEGrid.add(TITOLO__32);

            com.codecharge.components.Label LIVELLO__42 = new com.codecharge.components.Label("LIVELLO", "LIVELLO", this );
            LIVELLO__42.setType( com.codecharge.components.ControlType.TEXT );
            LIVELLO__42.setHtmlEncode( true );
            TITLEGrid.add(LIVELLO__42);
            add(TITLEGrid);
        } // End definition of TITLEGrid grid model
//End TITLEGrid grid

//PREFERENZE grid @6-62D6BDA7
        
        /*
            // Begin definition of PREFERENZE grid model.
        */
        {
            com.codecharge.components.Grid PREFERENZE = new com.codecharge.components.Grid("PREFERENZE");
            PREFERENZE.setPageModel( this );
            PREFERENZE.setFetchSize(20);
            PREFERENZE.setVisible( true );
            PREFERENZE.addGridListener( new PREFERENZEGridHandler() );

            com.codecharge.components.Link STRINGA__16 = new com.codecharge.components.Link("STRINGA", "STRINGA", this );
            STRINGA__16.setType( com.codecharge.components.ControlType.TEXT );
            STRINGA__16.setHtmlEncode( true );
            STRINGA__16.setHrefSourceValue( "AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX );
            STRINGA__16.setHrefType( "Page" );
            STRINGA__16.setConvertRule("Relative");
            STRINGA__16.setPreserveType(PreserveParameterType.GET);
            STRINGA__16.addParameter( new LinkParameter( "STRINGA", "STRINGA", ParameterSource.DATAFIELD) );
            PREFERENZE.add( STRINGA__16 );

            com.codecharge.components.Label IMPOSTATA__41 = new com.codecharge.components.Label("IMPOSTATA", "IMPOSTATA", this );
            IMPOSTATA__41.setType( com.codecharge.components.ControlType.TEXT );
            PREFERENZE.add(IMPOSTATA__41);

            com.codecharge.components.Label VALORE__7 = new com.codecharge.components.Label("VALORE", "VALORE", this );
            VALORE__7.setType( com.codecharge.components.ControlType.TEXT );
            VALORE__7.setHtmlEncode( true );
            PREFERENZE.add(VALORE__7);

            com.codecharge.components.Hidden COMMENTO__40 = new com.codecharge.components.Hidden("COMMENTO", "COMMENTO", this );
            COMMENTO__40.setType( com.codecharge.components.ControlType.TEXT );
            COMMENTO__40.setHtmlEncode( true );
            PREFERENZE.add( COMMENTO__40 );

            com.codecharge.components.Label AFCNavigator__43 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__43.setType( com.codecharge.components.ControlType.TEXT );
            PREFERENZE.add(AFCNavigator__43);
            add(PREFERENZE);
        } // End definition of PREFERENZE grid model
//End PREFERENZE grid

//PREFERENZA record @17-9F65EAF4
        
        /*
            Model of PREFERENZA record defining.
        */
        {
            com.codecharge.components.Record PREFERENZA = new com.codecharge.components.Record("PREFERENZA");
            PREFERENZA.setPageModel( this );
            PREFERENZA.addExcludeParam( "ccsForm" );
            PREFERENZA.addExcludeParam( "STRINGA" );
            PREFERENZA.setVisible( true );
            PREFERENZA.setAllowInsert(false);
            PREFERENZA.setPreserveType(PreserveParameterType.GET);
            PREFERENZA.setReturnPage("AdmPreferenzeImpostazione" + Names.ACTION_SUFFIX);
            PREFERENZA.addRecordListener(new PREFERENZARecordHandler());

            com.codecharge.components.Label STRINGA_LABEL__18 = new com.codecharge.components.Label("STRINGA_LABEL", "STRINGA", this );
            STRINGA_LABEL__18.setType( com.codecharge.components.ControlType.TEXT );
            STRINGA_LABEL__18.setHtmlEncode( true );
            PREFERENZA.add(STRINGA_LABEL__18);

            com.codecharge.components.Label COMMENTO__39 = new com.codecharge.components.Label("COMMENTO", "COMMENTO", this );
            COMMENTO__39.setType( com.codecharge.components.ControlType.TEXT );
            PREFERENZA.add(COMMENTO__39);

            com.codecharge.components.TextArea VALORE__19 = new com.codecharge.components.TextArea("VALORE", "VALORE", this );
            VALORE__19.setType( com.codecharge.components.ControlType.TEXT );
            VALORE__19.setHtmlEncode( true );
            VALORE__19.setCaption( "VALORE" );
            PREFERENZA.add( VALORE__19 );

            com.codecharge.components.Button Update__21 = new com.codecharge.components.Button("Update", this);
            Update__21.addExcludeParam( "ccsForm" );
            Update__21.addExcludeParam( "Update" );
            Update__21.setOperation( "Update" );
            PREFERENZA.add( Update__21 );

            com.codecharge.components.Button Delete__22 = new com.codecharge.components.Button("Delete", this);
            Delete__22.addExcludeParam( "ccsForm" );
            Delete__22.addExcludeParam( "Delete" );
            Delete__22.setOperation( "Delete" );
            PREFERENZA.add( Delete__22 );

            com.codecharge.components.Button Cancel__23 = new com.codecharge.components.Button("Cancel", this);
            Cancel__23.addExcludeParam( "ccsForm" );
            Cancel__23.addExcludeParam( "Cancel" );
            Cancel__23.addExcludeParam( "STRINGA" );
            Cancel__23.setOperation( "Cancel" );
            PREFERENZA.add( Cancel__23 );

            com.codecharge.components.Hidden STRINGA__44 = new com.codecharge.components.Hidden("STRINGA", "STRINGA", this );
            STRINGA__44.setType( com.codecharge.components.ControlType.TEXT );
            STRINGA__44.setHtmlEncode( true );
            PREFERENZA.add( STRINGA__44 );

            com.codecharge.components.Hidden MODULO__24 = new com.codecharge.components.Hidden("MODULO", "MODULO", this );
            MODULO__24.setType( com.codecharge.components.ControlType.TEXT );
            MODULO__24.setHtmlEncode( true );
            MODULO__24.setCaption( "MODULO" );
            PREFERENZA.add( MODULO__24 );
            add(PREFERENZA);
        } // End definition of PREFERENZA record model.
//End PREFERENZA record

//AdmPreferenzeImpostazioneModel class tail @1-F5FC18C5
    }
}
//End AdmPreferenzeImpostazioneModel class tail




