//AdmRilevanzeModel imports @1-9DC8269B
package amvadm.AdmRilevanze;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRilevanzeModel imports

//AdmRilevanzeModel class head @1-5D5E4B24
public class AdmRilevanzeModel extends com.codecharge.components.Page {
    public AdmRilevanzeModel() {
        this( new CCSLocale(), null );
    }

    public AdmRilevanzeModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRilevanzeModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRilevanzeModel class head

//page settings @1-0B11714E
        super("AdmRilevanze", locale );
        setResponse(response);
        addPageListener(new AdmRilevanzePageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__24 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__24.setVisible( true );
            add( Guida__24 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_RILEVANZE grid @5-42C33B1F
        
        /*
            // Begin definition of AMV_RILEVANZE grid model.
        */
        {
            com.codecharge.components.Grid AMV_RILEVANZE = new com.codecharge.components.Grid("AMV_RILEVANZE");
            AMV_RILEVANZE.setPageModel( this );
            AMV_RILEVANZE.setFetchSize(10);
            AMV_RILEVANZE.setVisible( true );
            AMV_RILEVANZE.addGridListener( new AMV_RILEVANZEGridHandler() );
            com.codecharge.components.Sorter Sorter_NOME = new com.codecharge.components.Sorter("Sorter_NOME", AMV_RILEVANZE, this);
            Sorter_NOME.setColumn("NOME");
            AMV_RILEVANZE.add(Sorter_NOME);
            com.codecharge.components.Sorter Sorter_IMPORTANZA = new com.codecharge.components.Sorter("Sorter_IMPORTANZA", AMV_RILEVANZE, this);
            Sorter_IMPORTANZA.setColumn("IMPORTANZA");
            AMV_RILEVANZE.add(Sorter_IMPORTANZA);
            com.codecharge.components.Sorter Sorter_SEQUENZA = new com.codecharge.components.Sorter("Sorter_SEQUENZA", AMV_RILEVANZE, this);
            Sorter_SEQUENZA.setColumn("SEQUENZA");
            AMV_RILEVANZE.add(Sorter_SEQUENZA);

            com.codecharge.components.Link NOME__9 = new com.codecharge.components.Link("NOME", "NOME", this );
            NOME__9.setType( com.codecharge.components.ControlType.TEXT );
            NOME__9.setHtmlEncode( true );
            NOME__9.setHrefSourceValue( "AdmRilevanze" + Names.ACTION_SUFFIX );
            NOME__9.setHrefType( "Page" );
            NOME__9.setConvertRule("Relative");
            NOME__9.setPreserveType(PreserveParameterType.GET);
            NOME__9.addParameter( new LinkParameter( "ID", "ID_RILEVANZA", ParameterSource.DATAFIELD) );
            AMV_RILEVANZE.add( NOME__9 );

            com.codecharge.components.Label IMPORTANZA__10 = new com.codecharge.components.Label("IMPORTANZA", "IMPORTANZA", this );
            IMPORTANZA__10.setType( com.codecharge.components.ControlType.TEXT );
            IMPORTANZA__10.setHtmlEncode( true );
            AMV_RILEVANZE.add(IMPORTANZA__10);

            com.codecharge.components.Label ZONA__33 = new com.codecharge.components.Label("ZONA", "ZONA_DES", this );
            ZONA__33.setType( com.codecharge.components.ControlType.TEXT );
            ZONA__33.setHtmlEncode( true );
            AMV_RILEVANZE.add(ZONA__33);

            com.codecharge.components.Label SEQUENZA__11 = new com.codecharge.components.Label("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__11.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__11.setHtmlEncode( true );
            AMV_RILEVANZE.add(SEQUENZA__11);

            com.codecharge.components.Label AFCNavigator__25 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__25.setType( com.codecharge.components.ControlType.TEXT );
            AMV_RILEVANZE.add(AFCNavigator__25);
            add(AMV_RILEVANZE);
        } // End definition of AMV_RILEVANZE grid model
//End AMV_RILEVANZE grid

//AMV_RILEVANZE_RECORD record @14-FA155790
        
        /*
            Model of AMV_RILEVANZE_RECORD record defining.
        */
        {
            com.codecharge.components.Record AMV_RILEVANZE_RECORD = new com.codecharge.components.Record("AMV_RILEVANZE_RECORD");
            AMV_RILEVANZE_RECORD.setPageModel( this );
            AMV_RILEVANZE_RECORD.addExcludeParam( "ccsForm" );
            AMV_RILEVANZE_RECORD.setVisible( true );
            AMV_RILEVANZE_RECORD.setPreserveType(PreserveParameterType.NONE);
            AMV_RILEVANZE_RECORD.setReturnPage("AdmRilevanze" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__21 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__21.setType( com.codecharge.components.ControlType.TEXT );
            NOME__21.setHtmlEncode( true );
            NOME__21.setCaption( "NOME" );
            NOME__21.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_RILEVANZE_RECORD.add( NOME__21 );

            com.codecharge.components.TextBox SEQUENZA__23 = new com.codecharge.components.TextBox("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__23.setType( com.codecharge.components.ControlType.INTEGER );
            SEQUENZA__23.setHtmlEncode( true );
            SEQUENZA__23.setFormatPattern( "0;(0)" );
            SEQUENZA__23.setCaption( "SEQUENZA" );
            AMV_RILEVANZE_RECORD.add( SEQUENZA__23 );

            com.codecharge.components.RadioButton ZONA__26 = new com.codecharge.components.RadioButton("ZONA", "ZONA", this );
            ZONA__26.setType( com.codecharge.components.ControlType.TEXT );
            ZONA__26.setHtmlEncode( true );
            ZONA__26.setCaption( "ZONA" );
            AMV_RILEVANZE_RECORD.add( ZONA__26 );

            com.codecharge.components.RadioButton ZONA_VISIBILITA__30 = new com.codecharge.components.RadioButton("ZONA_VISIBILITA", "ZONA_VISIBILITA", this );
            ZONA_VISIBILITA__30.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_VISIBILITA__30.setHtmlEncode( true );
            ZONA_VISIBILITA__30.setCaption( "Visibilità" );
            AMV_RILEVANZE_RECORD.add( ZONA_VISIBILITA__30 );

            com.codecharge.components.RadioButton ZONA_FORMATO__27 = new com.codecharge.components.RadioButton("ZONA_FORMATO", "ZONA_FORMATO", this );
            ZONA_FORMATO__27.setType( com.codecharge.components.ControlType.TEXT );
            ZONA_FORMATO__27.setHtmlEncode( true );
            ZONA_FORMATO__27.setCaption( "Tipo visualizzazione" );
            AMV_RILEVANZE_RECORD.add( ZONA_FORMATO__27 );

            com.codecharge.components.TextBox IMMAGINE__28 = new com.codecharge.components.TextBox("IMMAGINE", "IMMAGINE", this );
            IMMAGINE__28.setType( com.codecharge.components.ControlType.TEXT );
            IMMAGINE__28.setHtmlEncode( true );
            IMMAGINE__28.setCaption( "IMMAGINE" );
            AMV_RILEVANZE_RECORD.add( IMMAGINE__28 );

            com.codecharge.components.TextBox MAX_VIS__29 = new com.codecharge.components.TextBox("MAX_VIS", "MAX_VIS", this );
            MAX_VIS__29.setType( com.codecharge.components.ControlType.INTEGER );
            MAX_VIS__29.setHtmlEncode( true );
            MAX_VIS__29.setCaption( "MAX_VIS" );
            AMV_RILEVANZE_RECORD.add( MAX_VIS__29 );

            com.codecharge.components.RadioButton IMPORTANZA__22 = new com.codecharge.components.RadioButton("IMPORTANZA", "IMPORTANZA", this );
            IMPORTANZA__22.setType( com.codecharge.components.ControlType.TEXT );
            IMPORTANZA__22.setHtmlEncode( true );
            IMPORTANZA__22.setCaption( "IMPORTANZA" );
            AMV_RILEVANZE_RECORD.add( IMPORTANZA__22 );

            com.codecharge.components.TextBox ICONA__32 = new com.codecharge.components.TextBox("ICONA", "ICONA", this );
            ICONA__32.setType( com.codecharge.components.ControlType.TEXT );
            ICONA__32.setHtmlEncode( true );
            ICONA__32.setCaption( "ICONA" );
            AMV_RILEVANZE_RECORD.add( ICONA__32 );

            com.codecharge.components.Button Insert__15 = new com.codecharge.components.Button("Insert", this);
            Insert__15.addExcludeParam( "ccsForm" );
            Insert__15.addExcludeParam( "Insert" );
            Insert__15.setOperation( "Insert" );
            AMV_RILEVANZE_RECORD.add( Insert__15 );

            com.codecharge.components.Button Update__16 = new com.codecharge.components.Button("Update", this);
            Update__16.addExcludeParam( "ccsForm" );
            Update__16.addExcludeParam( "Update" );
            Update__16.setOperation( "Update" );
            AMV_RILEVANZE_RECORD.add( Update__16 );

            com.codecharge.components.Button Delete__17 = new com.codecharge.components.Button("Delete", this);
            Delete__17.addExcludeParam( "ccsForm" );
            Delete__17.addExcludeParam( "Delete" );
            Delete__17.setOperation( "Delete" );
            AMV_RILEVANZE_RECORD.add( Delete__17 );

            com.codecharge.components.Button Cancel__18 = new com.codecharge.components.Button("Cancel", this);
            Cancel__18.addExcludeParam( "ccsForm" );
            Cancel__18.addExcludeParam( "Cancel" );
            Cancel__18.setOperation( "Cancel" );
            AMV_RILEVANZE_RECORD.add( Cancel__18 );

            com.codecharge.components.Hidden ID_RILEVANZA__20 = new com.codecharge.components.Hidden("ID_RILEVANZA", "ID_RILEVANZA", this );
            ID_RILEVANZA__20.setType( com.codecharge.components.ControlType.INTEGER );
            ID_RILEVANZA__20.setHtmlEncode( true );
            ID_RILEVANZA__20.setCaption( "ID RILEVANZA" );
            AMV_RILEVANZE_RECORD.add( ID_RILEVANZA__20 );
            add(AMV_RILEVANZE_RECORD);
        } // End definition of AMV_RILEVANZE_RECORD record model.
//End AMV_RILEVANZE_RECORD record

//AdmRilevanzeModel class tail @1-F5FC18C5
    }
}
//End AdmRilevanzeModel class tail

