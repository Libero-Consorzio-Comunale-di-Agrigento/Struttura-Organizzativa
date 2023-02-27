//AdmSezioneModel imports @1-FEEA3902
package amvadm.AdmSezione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmSezioneModel imports

//AdmSezioneModel class head @1-7594D25B
public class AdmSezioneModel extends com.codecharge.components.Page {
    public AdmSezioneModel() {
        this( new CCSLocale(), null );
    }

    public AdmSezioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmSezioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmSezioneModel class head

//page settings @1-4CEF9CDC
        super("AdmSezione", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//AMV_SEZIONE_RECORD record @2-3DF6EC5E
        
        /*
            Model of AMV_SEZIONE_RECORD record defining.
        */
        {
            com.codecharge.components.Record AMV_SEZIONE_RECORD = new com.codecharge.components.Record("AMV_SEZIONE_RECORD");
            AMV_SEZIONE_RECORD.setPageModel( this );
            AMV_SEZIONE_RECORD.addExcludeParam( "ccsForm" );
            AMV_SEZIONE_RECORD.setVisible( true );
            AMV_SEZIONE_RECORD.setPreserveType(PreserveParameterType.GET);
            AMV_SEZIONE_RECORD.setReturnPage("AdmSezione" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__3 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__3.setType( com.codecharge.components.ControlType.TEXT );
            NOME__3.setHtmlEncode( true );
            NOME__3.setCaption( "NOME" );
            NOME__3.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_SEZIONE_RECORD.add( NOME__3 );

            com.codecharge.components.TextArea DESCRIZIONE__4 = new com.codecharge.components.TextArea("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__4.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__4.setHtmlEncode( true );
            DESCRIZIONE__4.setCaption( "DESCRIZIONE" );
            AMV_SEZIONE_RECORD.add( DESCRIZIONE__4 );

            com.codecharge.components.ListBox ID_PADRE__5 = new com.codecharge.components.ListBox("ID_PADRE", "ID_PADRE", this );
            ID_PADRE__5.setType( com.codecharge.components.ControlType.TEXT );
            ID_PADRE__5.setHtmlEncode( true );
            ID_PADRE__5.setCaption( "PADRE" );
            ID_PADRE__5.setBoundColumn( "ID_SEZIONE" );
            ID_PADRE__5.setTextColumn( "NOME" );
            ID_PADRE__5.addValidateHandler( new RequiredHandler( "Il valore nel campo PADRE è richiesto." ) );
            AMV_SEZIONE_RECORD.add( ID_PADRE__5 );

            com.codecharge.components.TextBox SEQUENZA__8 = new com.codecharge.components.TextBox("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__8.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__8.setHtmlEncode( true );
            SEQUENZA__8.setCaption( "SEQUENZA" );
            AMV_SEZIONE_RECORD.add( SEQUENZA__8 );

            com.codecharge.components.ListBox ID_AREA__33 = new com.codecharge.components.ListBox("ID_AREA", "ID_AREA", this );
            ID_AREA__33.setType( com.codecharge.components.ControlType.INTEGER );
            ID_AREA__33.setHtmlEncode( true );
            ID_AREA__33.setCaption( "AREA DI ACCESSO" );
            ID_AREA__33.setBoundColumn( "ID_AREA" );
            ID_AREA__33.setTextColumn( "NOME" );
            AMV_SEZIONE_RECORD.add( ID_AREA__33 );

            com.codecharge.components.RadioButton VISIBILITA__31 = new com.codecharge.components.RadioButton("VISIBILITA", "VISIBILITA", this );
            VISIBILITA__31.setType( com.codecharge.components.ControlType.TEXT );
            VISIBILITA__31.setHtmlEncode( true );
            VISIBILITA__31.setCaption( "Visibilità nel blocco padre" );
            AMV_SEZIONE_RECORD.add( VISIBILITA__31 );

            com.codecharge.components.RadioButton ZONA_ESPANSIONE__30 = new com.codecharge.components.RadioButton("ZONA_ESPANSIONE", "ZONA_ESPANSIONE", this );
            ZONA_ESPANSIONE__30.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_ESPANSIONE__30.setHtmlEncode( true );
            ZONA_ESPANSIONE__30.setCaption( "Espansione blocco" );
            AMV_SEZIONE_RECORD.add( ZONA_ESPANSIONE__30 );

            com.codecharge.components.RadioButton ZONA_TIPO__27 = new com.codecharge.components.RadioButton("ZONA_TIPO", "ZONA_TIPO", this );
            ZONA_TIPO__27.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_TIPO__27.setHtmlEncode( true );
            ZONA_TIPO__27.setCaption( "Tipo Blocco" );
            AMV_SEZIONE_RECORD.add( ZONA_TIPO__27 );

            com.codecharge.components.RadioButton ZONA__7 = new com.codecharge.components.RadioButton("ZONA", "ZONA", this );
            ZONA__7.setType( com.codecharge.components.ControlType.TEXT );
            ZONA__7.setHtmlEncode( true );
            ZONA__7.setCaption( "Zona di visualizzazione" );
            AMV_SEZIONE_RECORD.add( ZONA__7 );

            com.codecharge.components.RadioButton ZONA_VISIBILITA__29 = new com.codecharge.components.RadioButton("ZONA_VISIBILITA", "ZONA_VISIBILITA", this );
            ZONA_VISIBILITA__29.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_VISIBILITA__29.setHtmlEncode( true );
            ZONA_VISIBILITA__29.setCaption( "Visibilità" );
            AMV_SEZIONE_RECORD.add( ZONA_VISIBILITA__29 );

            com.codecharge.components.RadioButton ZONA_FORMATO__28 = new com.codecharge.components.RadioButton("ZONA_FORMATO", "ZONA_FORMATO", this );
            ZONA_FORMATO__28.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_FORMATO__28.setHtmlEncode( true );
            ZONA_FORMATO__28.setCaption( "Tipo visualizzazione" );
            AMV_SEZIONE_RECORD.add( ZONA_FORMATO__28 );

            com.codecharge.components.TextBox IMMAGINE__10 = new com.codecharge.components.TextBox("IMMAGINE", "IMMAGINE", this );
            IMMAGINE__10.setType( com.codecharge.components.ControlType.TEXT );
            IMMAGINE__10.setHtmlEncode( true );
            IMMAGINE__10.setCaption( "IMMAGINE" );
            AMV_SEZIONE_RECORD.add( IMMAGINE__10 );

            com.codecharge.components.TextBox MAX_VIS__9 = new com.codecharge.components.TextBox("MAX_VIS", "MAX_VIS", this );
            MAX_VIS__9.setType( com.codecharge.components.ControlType.INTEGER );
            MAX_VIS__9.setHtmlEncode( true );
            MAX_VIS__9.setCaption( "MAX_VIS" );
            AMV_SEZIONE_RECORD.add( MAX_VIS__9 );

            com.codecharge.components.TextBox ICONA__43 = new com.codecharge.components.TextBox("ICONA", "ICONA", this );
            ICONA__43.setType( com.codecharge.components.ControlType.TEXT );
            ICONA__43.setHtmlEncode( true );
            ICONA__43.setCaption( "ICONA" );
            AMV_SEZIONE_RECORD.add( ICONA__43 );

            com.codecharge.components.TextArea INTESTAZIONE__36 = new com.codecharge.components.TextArea("INTESTAZIONE", "INTESTAZIONE", this );
            INTESTAZIONE__36.setType( com.codecharge.components.ControlType.TEXT );
            INTESTAZIONE__36.setHtmlEncode( true );
            INTESTAZIONE__36.setCaption( "INTESTAZIONE" );
            AMV_SEZIONE_RECORD.add( INTESTAZIONE__36 );

            com.codecharge.components.TextBox LOGO_SX__37 = new com.codecharge.components.TextBox("LOGO_SX", "LOGO_SX", this );
            LOGO_SX__37.setType( com.codecharge.components.ControlType.TEXT );
            LOGO_SX__37.setHtmlEncode( true );
            AMV_SEZIONE_RECORD.add( LOGO_SX__37 );

            com.codecharge.components.TextBox LOGO_SX_LINK__38 = new com.codecharge.components.TextBox("LOGO_SX_LINK", "LOGO_SX_LINK", this );
            LOGO_SX_LINK__38.setType( com.codecharge.components.ControlType.TEXT );
            LOGO_SX_LINK__38.setHtmlEncode( true );
            LOGO_SX_LINK__38.setCaption( "Link logo sinistro" );
            AMV_SEZIONE_RECORD.add( LOGO_SX_LINK__38 );

            com.codecharge.components.TextBox LOGO_DX__39 = new com.codecharge.components.TextBox("LOGO_DX", "LOGO_DX", this );
            LOGO_DX__39.setType( com.codecharge.components.ControlType.TEXT );
            LOGO_DX__39.setHtmlEncode( true );
            LOGO_DX__39.setCaption( "Logo destro" );
            AMV_SEZIONE_RECORD.add( LOGO_DX__39 );

            com.codecharge.components.TextBox LOGO_DX_LINK__40 = new com.codecharge.components.TextBox("LOGO_DX_LINK", "LOGO_DX_LINK", this );
            LOGO_DX_LINK__40.setType( com.codecharge.components.ControlType.TEXT );
            LOGO_DX_LINK__40.setHtmlEncode( true );
            LOGO_DX_LINK__40.setCaption( "Link logo destro" );
            AMV_SEZIONE_RECORD.add( LOGO_DX_LINK__40 );

            com.codecharge.components.TextBox STYLE__41 = new com.codecharge.components.TextBox("STYLE", "STYLE", this );
            STYLE__41.setType( com.codecharge.components.ControlType.TEXT );
            STYLE__41.setHtmlEncode( true );
            STYLE__41.setCaption( "Stile" );
            AMV_SEZIONE_RECORD.add( STYLE__41 );

            com.codecharge.components.TextArea COPYRIGHT__42 = new com.codecharge.components.TextArea("COPYRIGHT", "COPYRIGHT", this );
            COPYRIGHT__42.setType( com.codecharge.components.ControlType.TEXT );
            COPYRIGHT__42.setHtmlEncode( true );
            COPYRIGHT__42.setCaption( "COPYRIGHT" );
            AMV_SEZIONE_RECORD.add( COPYRIGHT__42 );

            com.codecharge.components.Button Insert__11 = new com.codecharge.components.Button("Insert", this);
            Insert__11.addExcludeParam( "ccsForm" );
            Insert__11.addExcludeParam( "Insert" );
            Insert__11.setOperation( "Insert" );
            AMV_SEZIONE_RECORD.add( Insert__11 );

            com.codecharge.components.Button Update__12 = new com.codecharge.components.Button("Update", this);
            Update__12.addExcludeParam( "ccsForm" );
            Update__12.addExcludeParam( "Update" );
            Update__12.setOperation( "Update" );
            AMV_SEZIONE_RECORD.add( Update__12 );

            com.codecharge.components.Button Delete__13 = new com.codecharge.components.Button("Delete", this);
            Delete__13.addExcludeParam( "ccsForm" );
            Delete__13.addExcludeParam( "Delete" );
            Delete__13.setOperation( "Delete" );
            AMV_SEZIONE_RECORD.add( Delete__13 );

            com.codecharge.components.Button Cancel__14 = new com.codecharge.components.Button("Cancel", this);
            Cancel__14.addExcludeParam( "ccsForm" );
            Cancel__14.addExcludeParam( "Cancel" );
            Cancel__14.setOperation( "Cancel" );
            AMV_SEZIONE_RECORD.add( Cancel__14 );

            com.codecharge.components.Hidden ID_SEZIONE__15 = new com.codecharge.components.Hidden("ID_SEZIONE", "ID_SEZIONE", this );
            ID_SEZIONE__15.setType( com.codecharge.components.ControlType.INTEGER );
            ID_SEZIONE__15.setHtmlEncode( true );
            ID_SEZIONE__15.setCaption( "ID_SEZIONE" );
            AMV_SEZIONE_RECORD.add( ID_SEZIONE__15 );
            add(AMV_SEZIONE_RECORD);
        } // End definition of AMV_SEZIONE_RECORD record model.
//End AMV_SEZIONE_RECORD record

//AdmSezioneModel class tail @1-F5FC18C5
    }
}
//End AdmSezioneModel class tail

