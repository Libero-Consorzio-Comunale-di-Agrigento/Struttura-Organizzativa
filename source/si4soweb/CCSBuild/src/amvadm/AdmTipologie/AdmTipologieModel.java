//AdmTipologieModel imports @1-D46337FA
package amvadm.AdmTipologie;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmTipologieModel imports

//AdmTipologieModel class head @1-5970A510
public class AdmTipologieModel extends com.codecharge.components.Page {
    public AdmTipologieModel() {
        this( new CCSLocale(), null );
    }

    public AdmTipologieModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmTipologieModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmTipologieModel class head

//page settings @1-A1A41E1F
        super("AdmTipologie", locale );
        setResponse(response);
        addPageListener(new AdmTipologiePageHandler());
        {
            com.codecharge.components.IncludePage Header__4 = new com.codecharge.components.IncludePage("Header", this );
            Header__4.setVisible( true );
            add( Header__4 );
            com.codecharge.components.IncludePage Left__5 = new com.codecharge.components.IncludePage("Left", this );
            Left__5.setVisible( true );
            add( Left__5 );
            com.codecharge.components.IncludePage Guida__35 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__35.setVisible( true );
            add( Guida__35 );
            com.codecharge.components.IncludePage Footer__6 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__6.setVisible( true );
            add( Footer__6 );
        } // end page
//End page settings

//AMV_TIPOLOGIE grid @7-9DF1CE6B
        
        /*
            // Begin definition of AMV_TIPOLOGIE grid model.
        */
        {
            com.codecharge.components.Grid AMV_TIPOLOGIE = new com.codecharge.components.Grid("AMV_TIPOLOGIE");
            AMV_TIPOLOGIE.setPageModel( this );
            AMV_TIPOLOGIE.setFetchSize(10);
            AMV_TIPOLOGIE.setVisible( true );
            AMV_TIPOLOGIE.addGridListener( new AMV_TIPOLOGIEGridHandler() );
            com.codecharge.components.Sorter Sorter_NOME = new com.codecharge.components.Sorter("Sorter_NOME", AMV_TIPOLOGIE, this);
            Sorter_NOME.setColumn("NOME");
            AMV_TIPOLOGIE.add(Sorter_NOME);
            com.codecharge.components.Sorter Sorter_ZONA = new com.codecharge.components.Sorter("Sorter_ZONA", AMV_TIPOLOGIE, this);
            Sorter_ZONA.setColumn("ZONA");
            AMV_TIPOLOGIE.add(Sorter_ZONA);
            com.codecharge.components.Sorter Sorter_SEQUENZA = new com.codecharge.components.Sorter("Sorter_SEQUENZA", AMV_TIPOLOGIE, this);
            Sorter_SEQUENZA.setColumn("SEQUENZA");
            AMV_TIPOLOGIE.add(Sorter_SEQUENZA);
            com.codecharge.components.Sorter Sorter_IMMAGINE = new com.codecharge.components.Sorter("Sorter_IMMAGINE", AMV_TIPOLOGIE, this);
            Sorter_IMMAGINE.setColumn("IMMAGINE");
            AMV_TIPOLOGIE.add(Sorter_IMMAGINE);
            com.codecharge.components.Sorter Sorter_LINK = new com.codecharge.components.Sorter("Sorter_LINK", AMV_TIPOLOGIE, this);
            Sorter_LINK.setColumn("LINK");
            AMV_TIPOLOGIE.add(Sorter_LINK);

            com.codecharge.components.Link NOME__14 = new com.codecharge.components.Link("NOME", "NOME", this );
            NOME__14.setType( com.codecharge.components.ControlType.TEXT );
            NOME__14.setHtmlEncode( true );
            NOME__14.setHrefSourceValue( "AdmTipologie" + Names.ACTION_SUFFIX );
            NOME__14.setHrefType( "Page" );
            NOME__14.setConvertRule("Relative");
            NOME__14.setPreserveType(PreserveParameterType.GET);
            NOME__14.addParameter( new LinkParameter( "ID", "ID_TIPOLOGIA", ParameterSource.DATAFIELD) );
            AMV_TIPOLOGIE.add( NOME__14 );

            com.codecharge.components.Label ZONA__17 = new com.codecharge.components.Label("ZONA", "ZONA_DES", this );
            ZONA__17.setType( com.codecharge.components.ControlType.TEXT );
            ZONA__17.setHtmlEncode( true );
            AMV_TIPOLOGIE.add(ZONA__17);

            com.codecharge.components.Label SEQUENZA__18 = new com.codecharge.components.Label("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__18.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__18.setHtmlEncode( true );
            AMV_TIPOLOGIE.add(SEQUENZA__18);

            com.codecharge.components.Label IMMAGINE__19 = new com.codecharge.components.Label("IMMAGINE", "IMMAGINE", this );
            IMMAGINE__19.setType( com.codecharge.components.ControlType.TEXT );
            IMMAGINE__19.setHtmlEncode( true );
            AMV_TIPOLOGIE.add(IMMAGINE__19);

            com.codecharge.components.Label LINK__20 = new com.codecharge.components.Label("LINK", "LINK", this );
            LINK__20.setType( com.codecharge.components.ControlType.TEXT );
            LINK__20.setHtmlEncode( true );
            AMV_TIPOLOGIE.add(LINK__20);

            com.codecharge.components.Label AFCNavigator__38 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__38.setType( com.codecharge.components.ControlType.TEXT );
            AMV_TIPOLOGIE.add(AFCNavigator__38);
            add(AMV_TIPOLOGIE);
        } // End definition of AMV_TIPOLOGIE grid model
//End AMV_TIPOLOGIE grid

//AMV_TIPOLOGIE_RECORD record @22-49E981F7
        
        /*
            Model of AMV_TIPOLOGIE_RECORD record defining.
        */
        {
            com.codecharge.components.Record AMV_TIPOLOGIE_RECORD = new com.codecharge.components.Record("AMV_TIPOLOGIE_RECORD");
            AMV_TIPOLOGIE_RECORD.setPageModel( this );
            AMV_TIPOLOGIE_RECORD.addExcludeParam( "ccsForm" );
            AMV_TIPOLOGIE_RECORD.setVisible( true );
            AMV_TIPOLOGIE_RECORD.setPreserveType(PreserveParameterType.NONE);
            AMV_TIPOLOGIE_RECORD.setReturnPage("AdmTipologie" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__23 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__23.setType( com.codecharge.components.ControlType.TEXT );
            NOME__23.setHtmlEncode( true );
            NOME__23.setCaption( "NOME" );
            NOME__23.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_TIPOLOGIE_RECORD.add( NOME__23 );

            com.codecharge.components.TextArea DESCRIZIONE__24 = new com.codecharge.components.TextArea("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__24.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__24.setHtmlEncode( true );
            DESCRIZIONE__24.setCaption( "DESCRIZIONE" );
            AMV_TIPOLOGIE_RECORD.add( DESCRIZIONE__24 );

            com.codecharge.components.TextBox SEQUENZA__26 = new com.codecharge.components.TextBox("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__26.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__26.setHtmlEncode( true );
            SEQUENZA__26.setCaption( "SEQUENZA" );
            AMV_TIPOLOGIE_RECORD.add( SEQUENZA__26 );

            com.codecharge.components.TextBox LINK__28 = new com.codecharge.components.TextBox("LINK", "LINK", this );
            LINK__28.setType( com.codecharge.components.ControlType.TEXT );
            LINK__28.setHtmlEncode( true );
            LINK__28.setCaption( "LINK" );
            AMV_TIPOLOGIE_RECORD.add( LINK__28 );

            com.codecharge.components.RadioButton ZONA__39 = new com.codecharge.components.RadioButton("ZONA", "ZONA", this );
            ZONA__39.setType( com.codecharge.components.ControlType.TEXT );
            ZONA__39.setHtmlEncode( true );
            ZONA__39.setCaption( "ZONA" );
            AMV_TIPOLOGIE_RECORD.add( ZONA__39 );

            com.codecharge.components.RadioButton ZONA_VISIBILITA__43 = new com.codecharge.components.RadioButton("ZONA_VISIBILITA", "ZONA_VISIBILITA", this );
            ZONA_VISIBILITA__43.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_VISIBILITA__43.setHtmlEncode( true );
            ZONA_VISIBILITA__43.setCaption( "Visibilità" );
            AMV_TIPOLOGIE_RECORD.add( ZONA_VISIBILITA__43 );

            com.codecharge.components.RadioButton ZONA_FORMATO__40 = new com.codecharge.components.RadioButton("ZONA_FORMATO", "ZONA_FORMATO", this );
            ZONA_FORMATO__40.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_FORMATO__40.setHtmlEncode( true );
            ZONA_FORMATO__40.setCaption( "Tipo visualizzazione" );
            AMV_TIPOLOGIE_RECORD.add( ZONA_FORMATO__40 );

            com.codecharge.components.TextBox IMMAGINE__41 = new com.codecharge.components.TextBox("IMMAGINE", "IMMAGINE", this );
            IMMAGINE__41.setType( com.codecharge.components.ControlType.TEXT );
            IMMAGINE__41.setHtmlEncode( true );
            IMMAGINE__41.setCaption( "IMMAGINE" );
            AMV_TIPOLOGIE_RECORD.add( IMMAGINE__41 );

            com.codecharge.components.TextBox MAX_VIS__42 = new com.codecharge.components.TextBox("MAX_VIS", "MAX_VIS", this );
            MAX_VIS__42.setType( com.codecharge.components.ControlType.INTEGER );
            MAX_VIS__42.setHtmlEncode( true );
            MAX_VIS__42.setCaption( "MAX_VIS" );
            AMV_TIPOLOGIE_RECORD.add( MAX_VIS__42 );

            com.codecharge.components.TextBox ICONA__45 = new com.codecharge.components.TextBox("ICONA", "ICONA", this );
            ICONA__45.setType( com.codecharge.components.ControlType.TEXT );
            ICONA__45.setHtmlEncode( true );
            ICONA__45.setCaption( "ICONA" );
            AMV_TIPOLOGIE_RECORD.add( ICONA__45 );

            com.codecharge.components.Button Insert__29 = new com.codecharge.components.Button("Insert", this);
            Insert__29.addExcludeParam( "ccsForm" );
            Insert__29.addExcludeParam( "Insert" );
            Insert__29.setOperation( "Insert" );
            AMV_TIPOLOGIE_RECORD.add( Insert__29 );

            com.codecharge.components.Button Update__30 = new com.codecharge.components.Button("Update", this);
            Update__30.addExcludeParam( "ccsForm" );
            Update__30.addExcludeParam( "Update" );
            Update__30.setOperation( "Update" );
            AMV_TIPOLOGIE_RECORD.add( Update__30 );

            com.codecharge.components.Button Delete__31 = new com.codecharge.components.Button("Delete", this);
            Delete__31.addExcludeParam( "ccsForm" );
            Delete__31.addExcludeParam( "Delete" );
            Delete__31.setOperation( "Delete" );
            AMV_TIPOLOGIE_RECORD.add( Delete__31 );

            com.codecharge.components.Button Cancel__32 = new com.codecharge.components.Button("Cancel", this);
            Cancel__32.addExcludeParam( "ccsForm" );
            Cancel__32.addExcludeParam( "Cancel" );
            Cancel__32.setOperation( "Cancel" );
            AMV_TIPOLOGIE_RECORD.add( Cancel__32 );

            com.codecharge.components.Hidden ID_TIPOLOGIA__33 = new com.codecharge.components.Hidden("ID_TIPOLOGIA", "ID_TIPOLOGIA", this );
            ID_TIPOLOGIA__33.setType( com.codecharge.components.ControlType.INTEGER );
            ID_TIPOLOGIA__33.setHtmlEncode( true );
            ID_TIPOLOGIA__33.setCaption( "ID TIPOLOGIA" );
            AMV_TIPOLOGIE_RECORD.add( ID_TIPOLOGIA__33 );
            add(AMV_TIPOLOGIE_RECORD);
        } // End definition of AMV_TIPOLOGIE_RECORD record model.
//End AMV_TIPOLOGIE_RECORD record

//AdmTipologieModel class tail @1-F5FC18C5
    }
}
//End AdmTipologieModel class tail

