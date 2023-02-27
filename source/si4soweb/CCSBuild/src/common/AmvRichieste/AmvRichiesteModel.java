//AmvRichiesteModel imports @1-4925A970
package common.AmvRichieste;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRichiesteModel imports

//AmvRichiesteModel class head @1-E024B1BE
public class AmvRichiesteModel extends com.codecharge.components.Page {
    public AmvRichiesteModel() {
        this( new CCSLocale(), null );
    }

    public AmvRichiesteModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRichiesteModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRichiesteModel class head

//page settings @1-2BCA9001
        super("AmvRichieste", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__58 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__58.setVisible( true );
            add( Guida__58 );
            com.codecharge.components.IncludePage Right__83 = new com.codecharge.components.IncludePage("Right", this );
            Right__83.setVisible( true );
            add( Right__83 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VISTA_DOCUMENTISearch record @6-F613903D
        
        /*
            Model of AMV_VISTA_DOCUMENTISearch record defining.
        */
        {
            com.codecharge.components.Record AMV_VISTA_DOCUMENTISearch = new com.codecharge.components.Record("AMV_VISTA_DOCUMENTISearch");
            AMV_VISTA_DOCUMENTISearch.setPageModel( this );
            AMV_VISTA_DOCUMENTISearch.addExcludeParam( "ccsForm" );
            AMV_VISTA_DOCUMENTISearch.setVisible( true );
            AMV_VISTA_DOCUMENTISearch.setAllowInsert(false);
            AMV_VISTA_DOCUMENTISearch.setAllowUpdate(false);
            AMV_VISTA_DOCUMENTISearch.setAllowDelete(false);
            AMV_VISTA_DOCUMENTISearch.setPreserveType(PreserveParameterType.GET);
            AMV_VISTA_DOCUMENTISearch.setReturnPage("AmvRichieste" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label NOME_TIPOLOGIA__78 = new com.codecharge.components.Label("NOME_TIPOLOGIA", "NOME", this );
            NOME_TIPOLOGIA__78.setType( com.codecharge.components.ControlType.TEXT );
            NOME_TIPOLOGIA__78.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add(NOME_TIPOLOGIA__78);

            com.codecharge.components.Label TITOLO__77 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__77.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__77.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add(TITOLO__77);

            com.codecharge.components.TextBox s_TESTO__10 = new com.codecharge.components.TextBox("s_TESTO", "", this );
            s_TESTO__10.setType( com.codecharge.components.ControlType.TEXT );
            s_TESTO__10.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add( s_TESTO__10 );

            com.codecharge.components.Button DoSearch__7 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__7.addExcludeParam( "ccsForm" );
            DoSearch__7.addExcludeParam( "DoSearch" );
            DoSearch__7.setOperation( "Search" );
            AMV_VISTA_DOCUMENTISearch.add( DoSearch__7 );
            add(AMV_VISTA_DOCUMENTISearch);
        } // End definition of AMV_VISTA_DOCUMENTISearch record model.
//End AMV_VISTA_DOCUMENTISearch record

//AMV_VISTA_DOCUMENTI grid @5-E72EB187
        
        /*
            // Begin definition of AMV_VISTA_DOCUMENTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_VISTA_DOCUMENTI = new com.codecharge.components.Grid("AMV_VISTA_DOCUMENTI");
            AMV_VISTA_DOCUMENTI.setPageModel( this );
            AMV_VISTA_DOCUMENTI.setFetchSize(20);
            AMV_VISTA_DOCUMENTI.setVisible( true );
            AMV_VISTA_DOCUMENTI.addGridListener( new AMV_VISTA_DOCUMENTIGridHandler() );
            com.codecharge.components.Sorter Sorter_DATA_INSERIMENTO = new com.codecharge.components.Sorter("Sorter_DATA_INSERIMENTO", AMV_VISTA_DOCUMENTI, this);
            Sorter_DATA_INSERIMENTO.setColumn("DATA_INSERIMENTO");
            AMV_VISTA_DOCUMENTI.add(Sorter_DATA_INSERIMENTO);
            com.codecharge.components.Sorter SorterSTATO = new com.codecharge.components.Sorter("SorterSTATO", AMV_VISTA_DOCUMENTI, this);
            SorterSTATO.setColumn("STATO");
            AMV_VISTA_DOCUMENTI.add(SorterSTATO);
            com.codecharge.components.Sorter SorterAUTORE = new com.codecharge.components.Sorter("SorterAUTORE", AMV_VISTA_DOCUMENTI, this);
            SorterAUTORE.setColumn("NOME_AUTORE");
            AMV_VISTA_DOCUMENTI.add(SorterAUTORE);

            com.codecharge.components.Link ID_DOCUMENTO__84 = new com.codecharge.components.Link("ID_DOCUMENTO", "ID_DOCUMENTO", this );
            ID_DOCUMENTO__84.setType( com.codecharge.components.ControlType.TEXT );
            ID_DOCUMENTO__84.setHrefSource( "HREF" );
            ID_DOCUMENTO__84.setHrefType( "Database" );
            ID_DOCUMENTO__84.setConvertRule("Relative");
            ID_DOCUMENTO__84.setPreserveType(PreserveParameterType.NONE);
            AMV_VISTA_DOCUMENTI.add( ID_DOCUMENTO__84 );

            com.codecharge.components.Label DATA_INSERIMENTO__85 = new com.codecharge.components.Label("DATA_INSERIMENTO", "DATA_INSERIMENTO", this );
            DATA_INSERIMENTO__85.setType( com.codecharge.components.ControlType.DATE );
            DATA_INSERIMENTO__85.setHtmlEncode( true );
            DATA_INSERIMENTO__85.setFormatPattern( "dd/MM/yyyy H:mm" );
            AMV_VISTA_DOCUMENTI.add(DATA_INSERIMENTO__85);

            com.codecharge.components.Label STATO_DOCUMENTO__67 = new com.codecharge.components.Label("STATO_DOCUMENTO", "STATO_DOCUMENTO", this );
            STATO_DOCUMENTO__67.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(STATO_DOCUMENTO__67);

            com.codecharge.components.Label FLUSSO__74 = new com.codecharge.components.Label("FLUSSO", "FLUSSO", this );
            FLUSSO__74.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(FLUSSO__74);

            com.codecharge.components.Label AUTORE__68 = new com.codecharge.components.Label("AUTORE", "NOME_AUTORE", this );
            AUTORE__68.setType( com.codecharge.components.ControlType.TEXT );
            AUTORE__68.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTI.add(AUTORE__68);

            com.codecharge.components.Label AFCNavigator__66 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__66.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VISTA_DOCUMENTI.add(AFCNavigator__66);
            add(AMV_VISTA_DOCUMENTI);
        } // End definition of AMV_VISTA_DOCUMENTI grid model
//End AMV_VISTA_DOCUMENTI grid

//AmvRichiesteModel class tail @1-F5FC18C5
    }
}
//End AmvRichiesteModel class tail
