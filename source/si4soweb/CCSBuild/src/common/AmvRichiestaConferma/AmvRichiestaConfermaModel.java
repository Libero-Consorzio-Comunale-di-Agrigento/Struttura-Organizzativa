//AmvRichiestaConfermaModel imports @1-E50CA1B0
package common.AmvRichiestaConferma;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRichiestaConfermaModel imports

//AmvRichiestaConfermaModel class head @1-AF9E39D8
public class AmvRichiestaConfermaModel extends com.codecharge.components.Page {
    public AmvRichiestaConfermaModel() {
        this( new CCSLocale(), null );
    }

    public AmvRichiestaConfermaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRichiestaConfermaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRichiestaConfermaModel class head

//page settings @1-3B06AA7B
        super("AmvRichiestaConferma", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage Header__20 = new com.codecharge.components.IncludePage("Header", this );
            Header__20.setVisible( true );
            add( Header__20 );
            com.codecharge.components.IncludePage Left__21 = new com.codecharge.components.IncludePage("Left", this );
            Left__21.setVisible( true );
            add( Left__21 );
            com.codecharge.components.IncludePage Right__36 = new com.codecharge.components.IncludePage("Right", this );
            Right__36.setVisible( true );
            add( Right__36 );
            com.codecharge.components.IncludePage Footer__22 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__22.setVisible( true );
            add( Footer__22 );
        } // end page
//End page settings

//RICHIESTA_GRID grid @39-4A00D154
        
        /*
            // Begin definition of RICHIESTA_GRID grid model.
        */
        {
            com.codecharge.components.Grid RICHIESTA_GRID = new com.codecharge.components.Grid("RICHIESTA_GRID");
            RICHIESTA_GRID.setPageModel( this );
            RICHIESTA_GRID.setFetchSize(300);
            RICHIESTA_GRID.setVisible( true );
            RICHIESTA_GRID.addGridListener( new RICHIESTA_GRIDGridHandler() );

            com.codecharge.components.Label TITOLO__67 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__67.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__67.setHtmlEncode( true );
            RICHIESTA_GRID.add(TITOLO__67);

            com.codecharge.components.Label STATO_FUTURO__69 = new com.codecharge.components.Label("STATO_FUTURO", "STATO_FUTURO", this );
            STATO_FUTURO__69.setType( com.codecharge.components.ControlType.TEXT );
            STATO_FUTURO__69.setHtmlEncode( true );
            STATO_FUTURO__69.addControlListener( new RICHIESTA_GRIDSTATO_FUTUROHandler());
            RICHIESTA_GRID.add(STATO_FUTURO__69);

            com.codecharge.components.Label ID_RICHIESTA__72 = new com.codecharge.components.Label("ID_RICHIESTA", "ID_RICHIESTA", this );
            ID_RICHIESTA__72.setType( com.codecharge.components.ControlType.INTEGER );
            ID_RICHIESTA__72.setHtmlEncode( true );
            RICHIESTA_GRID.add(ID_RICHIESTA__72);

            com.codecharge.components.Link ELENCO_RICHIESTE_LINK__61 = new com.codecharge.components.Link("ELENCO_RICHIESTE_LINK", "ELENCO_RICHIESTE_SRC", this );
            ELENCO_RICHIESTE_LINK__61.setType( com.codecharge.components.ControlType.TEXT );
            ELENCO_RICHIESTE_LINK__61.setHtmlEncode( true );
            ELENCO_RICHIESTE_LINK__61.setHrefSource( "ELENCO_RICHIESTE_HREF" );
            ELENCO_RICHIESTE_LINK__61.setHrefType( "Database" );
            ELENCO_RICHIESTE_LINK__61.setConvertRule("Relative");
            ELENCO_RICHIESTE_LINK__61.setPreserveType(PreserveParameterType.GET);
            RICHIESTA_GRID.add( ELENCO_RICHIESTE_LINK__61 );

            com.codecharge.components.Link STAMPA_RICHIESTA__71 = new com.codecharge.components.Link("STAMPA_RICHIESTA", "STAMPA_RICHIESTA_SRC", this );
            STAMPA_RICHIESTA__71.setType( com.codecharge.components.ControlType.TEXT );
            STAMPA_RICHIESTA__71.setHtmlEncode( true );
            STAMPA_RICHIESTA__71.setHrefSource( "STAMPA_RICHIESTA_HREF" );
            STAMPA_RICHIESTA__71.setHrefType( "Database" );
            STAMPA_RICHIESTA__71.setConvertRule("Relative");
            STAMPA_RICHIESTA__71.setPreserveType(PreserveParameterType.GET);
            STAMPA_RICHIESTA__71.addParameter( new LinkParameter( "rw", "", ParameterSource.EXPRESSION) );
            RICHIESTA_GRID.add( STAMPA_RICHIESTA__71 );

            com.codecharge.components.Link MODIFICA_RICHIESTA_LINK__62 = new com.codecharge.components.Link("MODIFICA_RICHIESTA_LINK", "MODIFICA_RICHIESTA_SRC", this );
            MODIFICA_RICHIESTA_LINK__62.setType( com.codecharge.components.ControlType.TEXT );
            MODIFICA_RICHIESTA_LINK__62.setHtmlEncode( true );
            MODIFICA_RICHIESTA_LINK__62.setHrefSource( "MODIFICA_RICHIESTA_HREF" );
            MODIFICA_RICHIESTA_LINK__62.setHrefType( "Database" );
            MODIFICA_RICHIESTA_LINK__62.setConvertRule("Relative");
            MODIFICA_RICHIESTA_LINK__62.setPreserveType(PreserveParameterType.GET);
            MODIFICA_RICHIESTA_LINK__62.addParameter( new LinkParameter( "rw", "", ParameterSource.EXPRESSION) );
            RICHIESTA_GRID.add( MODIFICA_RICHIESTA_LINK__62 );

            com.codecharge.components.Link CONFERMA_RICHIESTA_LINK__63 = new com.codecharge.components.Link("CONFERMA_RICHIESTA_LINK", "CONFERMA_RICHIESTA_SRC", this );
            CONFERMA_RICHIESTA_LINK__63.setType( com.codecharge.components.ControlType.TEXT );
            CONFERMA_RICHIESTA_LINK__63.setHtmlEncode( true );
            CONFERMA_RICHIESTA_LINK__63.setHrefSource( "CONFERMA_RICHIESTA_HREF" );
            CONFERMA_RICHIESTA_LINK__63.setHrefType( "Database" );
            CONFERMA_RICHIESTA_LINK__63.setConvertRule("Relative");
            CONFERMA_RICHIESTA_LINK__63.setPreserveType(PreserveParameterType.NONE);
            RICHIESTA_GRID.add( CONFERMA_RICHIESTA_LINK__63 );
            add(RICHIESTA_GRID);
        } // End definition of RICHIESTA_GRID grid model
//End RICHIESTA_GRID grid

//AmvRichiestaConfermaModel class tail @1-F5FC18C5
    }
}
//End AmvRichiestaConfermaModel class tail
