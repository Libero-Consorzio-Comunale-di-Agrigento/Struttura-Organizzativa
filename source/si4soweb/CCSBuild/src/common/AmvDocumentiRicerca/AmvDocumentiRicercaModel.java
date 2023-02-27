//AmvDocumentiRicercaModel imports @1-ED493DE6
package common.AmvDocumentiRicerca;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvDocumentiRicercaModel imports

//AmvDocumentiRicercaModel class head @1-85E2DAD2
public class AmvDocumentiRicercaModel extends com.codecharge.components.Page {
    public AmvDocumentiRicercaModel() {
        this( new CCSLocale(), null );
    }

    public AmvDocumentiRicercaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvDocumentiRicercaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvDocumentiRicercaModel class head

//page settings @1-CA331CD0
        super("AmvDocumentiRicerca", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__57 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__57.setVisible( true );
            add( Guida__57 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VISTA_DOCUMENTISearch record @6-0CABDC1B
        
        /*
            Model of AMV_VISTA_DOCUMENTISearch record defining.
        */
        {
            com.codecharge.components.Record AMV_VISTA_DOCUMENTISearch = new com.codecharge.components.Record("AMV_VISTA_DOCUMENTISearch");
            AMV_VISTA_DOCUMENTISearch.setPageModel( this );
            AMV_VISTA_DOCUMENTISearch.addExcludeParam( "ccsForm" );
            AMV_VISTA_DOCUMENTISearch.addExcludeParam( "MVTD" );
            AMV_VISTA_DOCUMENTISearch.setVisible( true );
            AMV_VISTA_DOCUMENTISearch.setAllowInsert(false);
            AMV_VISTA_DOCUMENTISearch.setAllowUpdate(false);
            AMV_VISTA_DOCUMENTISearch.setAllowDelete(false);
            AMV_VISTA_DOCUMENTISearch.setPreserveType(PreserveParameterType.GET);
            AMV_VISTA_DOCUMENTISearch.setReturnPage("AmvDocumentiRicerca" + Names.ACTION_SUFFIX);
            AMV_VISTA_DOCUMENTISearch.addRecordListener(new AMV_VISTA_DOCUMENTISearchRecordHandler());

            com.codecharge.components.TextBox s_TESTO__10 = new com.codecharge.components.TextBox("s_TESTO", "", this );
            s_TESTO__10.setType( com.codecharge.components.ControlType.TEXT );
            s_TESTO__10.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add( s_TESTO__10 );

            com.codecharge.components.CheckBox s_CERCA_TESTO__73=  new com.codecharge.components.CheckBox( "s_CERCA_TESTO", "", this );
            s_CERCA_TESTO__73.setType( com.codecharge.components.ControlType.TEXT );
            s_CERCA_TESTO__73.setCheckedValue( 1 );
            s_CERCA_TESTO__73.setUncheckedValue( 0 );
            AMV_VISTA_DOCUMENTISearch.add(s_CERCA_TESTO__73);

            com.codecharge.components.ListBox s_DISPLAY__75 = new com.codecharge.components.ListBox("s_DISPLAY", "", this );
            s_DISPLAY__75.setType( com.codecharge.components.ControlType.TEXT );
            s_DISPLAY__75.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add( s_DISPLAY__75 );

            com.codecharge.components.ListBox s_ID_SEZIONE__72 = new com.codecharge.components.ListBox("s_ID_SEZIONE", "", this );
            s_ID_SEZIONE__72.setType( com.codecharge.components.ControlType.INTEGER );
            s_ID_SEZIONE__72.setHtmlEncode( true );
            s_ID_SEZIONE__72.setBoundColumn( "ID_SEZIONE" );
            s_ID_SEZIONE__72.setTextColumn( "NOME" );
            AMV_VISTA_DOCUMENTISearch.add( s_ID_SEZIONE__72 );

            com.codecharge.components.ListBox s_ID_TIPOLOGIA__8 = new com.codecharge.components.ListBox("s_ID_TIPOLOGIA", "TIPOLOGIA", this );
            s_ID_TIPOLOGIA__8.setType( com.codecharge.components.ControlType.INTEGER );
            s_ID_TIPOLOGIA__8.setHtmlEncode( true );
            s_ID_TIPOLOGIA__8.setBoundColumn( "ID_TIPOLOGIA" );
            s_ID_TIPOLOGIA__8.setTextColumn( "NOME" );
            AMV_VISTA_DOCUMENTISearch.add( s_ID_TIPOLOGIA__8 );

            com.codecharge.components.ListBox s_ID_CATEGORIA__90 = new com.codecharge.components.ListBox("s_ID_CATEGORIA", "", this );
            s_ID_CATEGORIA__90.setType( com.codecharge.components.ControlType.INTEGER );
            s_ID_CATEGORIA__90.setHtmlEncode( true );
            s_ID_CATEGORIA__90.setBoundColumn( "ID_CATEGORIA" );
            s_ID_CATEGORIA__90.setTextColumn( "NOME" );
            AMV_VISTA_DOCUMENTISearch.add( s_ID_CATEGORIA__90 );

            com.codecharge.components.ListBox s_ID_ARGOMENTO__91 = new com.codecharge.components.ListBox("s_ID_ARGOMENTO", "", this );
            s_ID_ARGOMENTO__91.setType( com.codecharge.components.ControlType.INTEGER );
            s_ID_ARGOMENTO__91.setHtmlEncode( true );
            s_ID_ARGOMENTO__91.setBoundColumn( "ID_ARGOMENTO" );
            s_ID_ARGOMENTO__91.setTextColumn( "NOME" );
            AMV_VISTA_DOCUMENTISearch.add( s_ID_ARGOMENTO__91 );

            com.codecharge.components.Button RicercaAvanzata__89 = new com.codecharge.components.Button("RicercaAvanzata", this);
            RicercaAvanzata__89.addExcludeParam( "ccsForm" );
            RicercaAvanzata__89.addExcludeParam( "RicercaAvanzata" );
            AMV_VISTA_DOCUMENTISearch.add( RicercaAvanzata__89 );

            com.codecharge.components.Button DoSearch__7 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__7.addExcludeParam( "ccsForm" );
            DoSearch__7.addExcludeParam( "DoSearch" );
            DoSearch__7.setOperation( "Search" );
            AMV_VISTA_DOCUMENTISearch.add( DoSearch__7 );
            add(AMV_VISTA_DOCUMENTISearch);
        } // End definition of AMV_VISTA_DOCUMENTISearch record model.
//End AMV_VISTA_DOCUMENTISearch record

//AMV_VISTA_DOCUMENTI grid @5-01AF143C
        
        /*
            // Begin definition of AMV_VISTA_DOCUMENTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_VISTA_DOCUMENTI = new com.codecharge.components.Grid("AMV_VISTA_DOCUMENTI");
            AMV_VISTA_DOCUMENTI.setPageModel( this );
            AMV_VISTA_DOCUMENTI.setFetchSize(10);
            AMV_VISTA_DOCUMENTI.setVisible( true );
            AMV_VISTA_DOCUMENTI.addGridListener( new AMV_VISTA_DOCUMENTIGridHandler() );
            com.codecharge.components.Sorter Sorter_TITOLO = new com.codecharge.components.Sorter("Sorter_TITOLO", AMV_VISTA_DOCUMENTI, this);
            Sorter_TITOLO.setColumn("TITOLO");
            AMV_VISTA_DOCUMENTI.add(Sorter_TITOLO);
            com.codecharge.components.Sorter SorterMODIFICA = new com.codecharge.components.Sorter("SorterMODIFICA", AMV_VISTA_DOCUMENTI, this);
            SorterMODIFICA.setColumn("DATA_ULTIMA_MODIFICA");
            AMV_VISTA_DOCUMENTI.add(SorterMODIFICA);

            com.codecharge.components.Link TITOLO__32 = new com.codecharge.components.Link("TITOLO", "TITOLO", this );
            TITOLO__32.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__32.setHtmlEncode( true );
            TITOLO__32.setHrefSourceValue( "AmvDocumentoInfo" + Names.ACTION_SUFFIX );
            TITOLO__32.setHrefType( "Page" );
            TITOLO__32.setConvertRule("Relative");
            TITOLO__32.setPreserveType(PreserveParameterType.NONE);
            TITOLO__32.addParameter( new LinkParameter( "ID", "ID_DOCUMENTO", ParameterSource.DATAFIELD) );
            TITOLO__32.addParameter( new LinkParameter( "REV", "REVISIONE", ParameterSource.DATAFIELD) );
            TITOLO__32.addParameter( new LinkParameter( "MVTD", "ID_TIPOLOGIA", ParameterSource.DATAFIELD) );
            TITOLO__32.addParameter( new LinkParameter( "MVSZ", "ID_SEZIONE", ParameterSource.DATAFIELD) );
            AMV_VISTA_DOCUMENTI.add( TITOLO__32 );

            com.codecharge.components.Label SEZIONE__78 = new com.codecharge.components.Label("SEZIONE", "DES_SEZIONE", this );
            SEZIONE__78.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(SEZIONE__78);

            com.codecharge.components.Label DATA_ULTIMA_MODIFICA__82 = new com.codecharge.components.Label("DATA_ULTIMA_MODIFICA", "DATA_ULTIMA_MODIFICA", this );
            DATA_ULTIMA_MODIFICA__82.setType( com.codecharge.components.ControlType.DATE );
            DATA_ULTIMA_MODIFICA__82.setFormatPattern( "dd/MM/yyyy" );
            AMV_VISTA_DOCUMENTI.add(DATA_ULTIMA_MODIFICA__82);

            com.codecharge.components.Label MODIFICA__83 = new com.codecharge.components.Label("MODIFICA", "MOD_SRC", this );
            MODIFICA__83.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(MODIFICA__83);

            com.codecharge.components.Label AFCNavigator__70 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__70.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(AFCNavigator__70);
            add(AMV_VISTA_DOCUMENTI);
        } // End definition of AMV_VISTA_DOCUMENTI grid model
//End AMV_VISTA_DOCUMENTI grid

//AmvDocumentiRicercaModel class tail @1-F5FC18C5
    }
}
//End AmvDocumentiRicercaModel class tail

