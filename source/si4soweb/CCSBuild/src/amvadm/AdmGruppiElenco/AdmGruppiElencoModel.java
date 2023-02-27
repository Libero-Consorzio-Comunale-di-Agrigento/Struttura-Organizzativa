//AdmGruppiElencoModel imports @1-B05B68D1
package amvadm.AdmGruppiElenco;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmGruppiElencoModel imports

//AdmGruppiElencoModel class head @1-5C16F4B0
public class AdmGruppiElencoModel extends com.codecharge.components.Page {
    public AdmGruppiElencoModel() {
        this( new CCSLocale(), null );
    }

    public AdmGruppiElencoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmGruppiElencoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmGruppiElencoModel class head

//page settings @1-7C9DBC0A
        super("AdmGruppiElenco", locale );
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

//AD4_UTENTISearch record @6-8E8A9DE3
        
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
            AD4_UTENTISearch.setReturnPage("AdmGruppiElenco" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox s_TESTO__10 = new com.codecharge.components.TextBox("s_TESTO", "", this );
            s_TESTO__10.setType( com.codecharge.components.ControlType.TEXT );
            s_TESTO__10.setHtmlEncode( true );
            AD4_UTENTISearch.add( s_TESTO__10 );

            com.codecharge.components.Hidden ID__50 = new com.codecharge.components.Hidden("ID", "UTENTE", this );
            ID__50.setType( com.codecharge.components.ControlType.TEXT );
            ID__50.setHtmlEncode( true );
            AD4_UTENTISearch.add( ID__50 );

            com.codecharge.components.Button DoSearch__7 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__7.addExcludeParam( "ccsForm" );
            DoSearch__7.addExcludeParam( "DoSearch" );
            DoSearch__7.setOperation( "Search" );
            AD4_UTENTISearch.add( DoSearch__7 );
            add(AD4_UTENTISearch);
        } // End definition of AD4_UTENTISearch record model.
//End AD4_UTENTISearch record

//AD4_UTENTI grid @5-240AC10F
        
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
            Sorter_NOMINATIVO.setColumn("NOME_GRUPPO");
            AD4_UTENTI.add(Sorter_NOMINATIVO);

            com.codecharge.components.Link NOME_GRUPPO__32 = new com.codecharge.components.Link("NOME_GRUPPO", "NOME_GRUPPO", this );
            NOME_GRUPPO__32.setType( com.codecharge.components.ControlType.TEXT );
            NOME_GRUPPO__32.setHtmlEncode( true );
            NOME_GRUPPO__32.setHrefSourceValue( "AdmGruppoUtenti" + Names.ACTION_SUFFIX );
            NOME_GRUPPO__32.setHrefType( "Page" );
            NOME_GRUPPO__32.setConvertRule("Relative");
            NOME_GRUPPO__32.setPreserveType(PreserveParameterType.GET);
            NOME_GRUPPO__32.addExcludeParam( "s_TESTO" );
            NOME_GRUPPO__32.addExcludeParam( "MVVC" );
            NOME_GRUPPO__32.addParameter( new LinkParameter( "IDUTE", "GRUPPO", ParameterSource.DATAFIELD) );
            AD4_UTENTI.add( NOME_GRUPPO__32 );

            com.codecharge.components.Label DIRITTI__69 = new com.codecharge.components.Label("DIRITTI", "DIRITTI", this );
            DIRITTI__69.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTI.add(DIRITTI__69);

            com.codecharge.components.Label AFCNavigator__72 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__72.setType( com.codecharge.components.ControlType.TEXT );
            AD4_UTENTI.add(AFCNavigator__72);
            add(AD4_UTENTI);
        } // End definition of AD4_UTENTI grid model
//End AD4_UTENTI grid

//AdmGruppiElencoModel class tail @1-F5FC18C5
    }
}
//End AdmGruppiElencoModel class tail



