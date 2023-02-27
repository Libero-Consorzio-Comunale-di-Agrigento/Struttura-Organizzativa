//AdmUtentiElencoModel imports @1-B5EF58E0
package amvadm.AdmUtentiElenco;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmUtentiElencoModel imports

//AdmUtentiElencoModel class head @1-4DCDF4BC
public class AdmUtentiElencoModel extends com.codecharge.components.Page {
    public AdmUtentiElencoModel() {
        this( new CCSLocale(), null );
    }

    public AdmUtentiElencoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmUtentiElencoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmUtentiElencoModel class head

//page settings @1-FA077F65
        super("AdmUtentiElenco", locale );
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
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTISearch record @6-AB2A5CCF
        
        /*
            Model of AD4_UTENTISearch record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTISearch = new com.codecharge.components.Record("AD4_UTENTISearch");
            AD4_UTENTISearch.setPageModel( this );
            AD4_UTENTISearch.addExcludeParam( "ccsForm" );
            AD4_UTENTISearch.setVisible( true );
            AD4_UTENTISearch.setAllowInsert(false);
            AD4_UTENTISearch.setAllowUpdate(false);
            AD4_UTENTISearch.setAllowDelete(false);
            AD4_UTENTISearch.setPreserveType(PreserveParameterType.NONE);
            AD4_UTENTISearch.setReturnPage("AdmUtentiElenco" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox s_TESTO__10 = new com.codecharge.components.TextBox("s_TESTO", "", this );
            s_TESTO__10.setType( com.codecharge.components.ControlType.TEXT );
            s_TESTO__10.setHtmlEncode( true );
            AD4_UTENTISearch.add( s_TESTO__10 );

            com.codecharge.components.Hidden ID__50 = new com.codecharge.components.Hidden("ID", "GRUPPO", this );
            ID__50.setType( com.codecharge.components.ControlType.TEXT );
            ID__50.setHtmlEncode( true );
            AD4_UTENTISearch.add( ID__50 );

            com.codecharge.components.Hidden RICERCA__72 = new com.codecharge.components.Hidden("RICERCA", "RICERCA", this );
            RICERCA__72.setType( com.codecharge.components.ControlType.TEXT );
            RICERCA__72.setHtmlEncode( true );
            AD4_UTENTISearch.add( RICERCA__72 );

            com.codecharge.components.Button DoSearch__7 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__7.addExcludeParam( "ccsForm" );
            DoSearch__7.addExcludeParam( "DoSearch" );
            DoSearch__7.setOperation( "Search" );
            AD4_UTENTISearch.add( DoSearch__7 );
            add(AD4_UTENTISearch);
        } // End definition of AD4_UTENTISearch record model.
//End AD4_UTENTISearch record

//AD4_UTENTI grid @5-3AE9D74D
        
        /*
            // Begin definition of AD4_UTENTI grid model.
        */
        {
            com.codecharge.components.Grid AD4_UTENTI = new com.codecharge.components.Grid("AD4_UTENTI");
            AD4_UTENTI.setPageModel( this );
            AD4_UTENTI.setFetchSize(20);
            AD4_UTENTI.setVisible( true );
            AD4_UTENTI.addGridListener( new AD4_UTENTIGridHandler() );
            com.codecharge.components.Sorter Sorter_NOMINATIVO = new com.codecharge.components.Sorter("Sorter_NOMINATIVO", AD4_UTENTI, this);
            Sorter_NOMINATIVO.setColumn("NOMINATIVO");
            AD4_UTENTI.add(Sorter_NOMINATIVO);

            com.codecharge.components.Link NOMINATIVO__32 = new com.codecharge.components.Link("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__32.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__32.setHtmlEncode( true );
            NOMINATIVO__32.setHrefSourceValue( "AdmUtenteDatiInfo" + Names.ACTION_SUFFIX );
            NOMINATIVO__32.setHrefType( "Page" );
            NOMINATIVO__32.setConvertRule("Relative");
            NOMINATIVO__32.setPreserveType(PreserveParameterType.NONE);
            NOMINATIVO__32.addParameter( new LinkParameter( "IDUTE", "UTENTE", ParameterSource.DATAFIELD) );
            NOMINATIVO__32.addParameter( new LinkParameter( "MVVC", "", ParameterSource.EXPRESSION) );
            AD4_UTENTI.add( NOMINATIVO__32 );

            com.codecharge.components.Label GRUPPI__69 = new com.codecharge.components.Label("GRUPPI", "GRUPPI", this );
            GRUPPI__69.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPI__69.setHtmlEncode( true );
            AD4_UTENTI.add(GRUPPI__69);

            com.codecharge.components.Label AFCNavigator__74 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__74.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTI.add(AFCNavigator__74);
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI grid model
//End AD4_UTENTI grid

//AdmUtentiElencoModel class tail @1-F5FC18C5
    }
}
//End AdmUtentiElencoModel class tail


