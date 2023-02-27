//AdmGruppoUtentiModel imports @1-BFC8D73D
package amvadm.AdmGruppoUtenti;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmGruppoUtentiModel imports

//AdmGruppoUtentiModel class head @1-76E28AAF
public class AdmGruppoUtentiModel extends com.codecharge.components.Page {
    public AdmGruppoUtentiModel() {
        this( new CCSLocale(), null );
    }

    public AdmGruppoUtentiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmGruppoUtentiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmGruppoUtentiModel class head

//page settings @1-7687F466
        super("AdmGruppoUtenti", locale );
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
            com.codecharge.components.IncludePage AmvUtenteNominativo_i__67 = new com.codecharge.components.IncludePage("AmvUtenteNominativo_i", this );
            AmvUtenteNominativo_i__67.setVisible( true );
            add( AmvUtenteNominativo_i__67 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AD4_UTENTISearch record @68-A75FC92E
        
        /*
            Model of AD4_UTENTISearch record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTISearch = new com.codecharge.components.Record("AD4_UTENTISearch");
            AD4_UTENTISearch.setPageModel( this );
            AD4_UTENTISearch.addExcludeParam( "ccsForm" );
            AD4_UTENTISearch.addExcludeParam( "s_TESTO" );
            AD4_UTENTISearch.setVisible( true );
            AD4_UTENTISearch.setAllowInsert(false);
            AD4_UTENTISearch.setAllowUpdate(false);
            AD4_UTENTISearch.setAllowDelete(false);
            AD4_UTENTISearch.setPreserveType(PreserveParameterType.NONE);
            AD4_UTENTISearch.setReturnPage("AdmGruppoUtenti" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox s_TESTO__69 = new com.codecharge.components.TextBox("s_TESTO", "", this );
            s_TESTO__69.setType( com.codecharge.components.ControlType.TEXT );
            s_TESTO__69.setHtmlEncode( true );
            AD4_UTENTISearch.add( s_TESTO__69 );

            com.codecharge.components.Hidden ID__70 = new com.codecharge.components.Hidden("ID", "GRUPPO", this );
            ID__70.setType( com.codecharge.components.ControlType.TEXT );
            ID__70.setHtmlEncode( true );
            AD4_UTENTISearch.add( ID__70 );

            com.codecharge.components.Hidden RICERCA__71 = new com.codecharge.components.Hidden("RICERCA", "RICERCA", this );
            RICERCA__71.setType( com.codecharge.components.ControlType.TEXT );
            RICERCA__71.setHtmlEncode( true );
            AD4_UTENTISearch.add( RICERCA__71 );

            com.codecharge.components.Button DoSearch__72 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__72.addExcludeParam( "ccsForm" );
            DoSearch__72.addExcludeParam( "DoSearch" );
            DoSearch__72.setOperation( "Search" );
            AD4_UTENTISearch.add( DoSearch__72 );
            add(AD4_UTENTISearch);
        } // End definition of AD4_UTENTISearch record model.
//End AD4_UTENTISearch record

//AD4_UTENTI grid @74-4258E034
        
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

            com.codecharge.components.Link NOMINATIVO__76 = new com.codecharge.components.Link("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__76.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__76.setHtmlEncode( true );
            NOMINATIVO__76.setHrefSourceValue( "AdmUtenteDatiInfo" + Names.ACTION_SUFFIX );
            NOMINATIVO__76.setHrefType( "Page" );
            NOMINATIVO__76.setConvertRule("Relative");
            NOMINATIVO__76.setPreserveType(PreserveParameterType.NONE);
            NOMINATIVO__76.addParameter( new LinkParameter( "IDUTE", "UTENTE", ParameterSource.DATAFIELD) );
            NOMINATIVO__76.addParameter( new LinkParameter( "MVVC", "", ParameterSource.EXPRESSION) );
            AD4_UTENTI.add( NOMINATIVO__76 );

            com.codecharge.components.Label GRUPPI__79 = new com.codecharge.components.Label("GRUPPI", "GRUPPI", this );
            GRUPPI__79.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPI__79.setHtmlEncode( true );
            AD4_UTENTI.add(GRUPPI__79);

            com.codecharge.components.Label AFCNavigator__98 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__98.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTI.add(AFCNavigator__98);
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI grid model
//End AD4_UTENTI grid

//AdmGruppoUtentiModel class tail @1-F5FC18C5
    }
}
//End AdmGruppoUtentiModel class tail


