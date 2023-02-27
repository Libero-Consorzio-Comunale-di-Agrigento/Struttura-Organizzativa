//AmvUtenteDatiInfoModel imports @1-C79957B5
package restrict.AmvUtenteDatiInfo;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUtenteDatiInfoModel imports

//AmvUtenteDatiInfoModel class head @1-C8A9F488
public class AmvUtenteDatiInfoModel extends com.codecharge.components.Page {
    public AmvUtenteDatiInfoModel() {
        this( new CCSLocale(), null );
    }

    public AmvUtenteDatiInfoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUtenteDatiInfoModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUtenteDatiInfoModel class head

//page settings @1-65EAB63F
        super("AmvUtenteDatiInfo", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__4 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__4.setVisible( true );
            add( AmvGuida__4 );
            com.codecharge.components.IncludePage Footer__5 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__5.setVisible( true );
            add( Footer__5 );
        } // end page
//End page settings

//AD4_UTENTE record @6-23562554
        
        /*
            Model of AD4_UTENTE record defining.
        */
        {
            com.codecharge.components.Record AD4_UTENTE = new com.codecharge.components.Record("AD4_UTENTE");
            AD4_UTENTE.setPageModel( this );
            AD4_UTENTE.addExcludeParam( "ccsForm" );
            AD4_UTENTE.setVisible( true );
            AD4_UTENTE.setAllowInsert(false);
            AD4_UTENTE.setAllowUpdate(false);
            AD4_UTENTE.setAllowDelete(false);
            AD4_UTENTE.setPreserveType(PreserveParameterType.ALL);
            AD4_UTENTE.setReturnPage("AmvUtenteDatiInfo" + Names.ACTION_SUFFIX);
            AD4_UTENTE.addRecordListener(new AD4_UTENTERecordHandler());

            com.codecharge.components.Label NOME__7 = new com.codecharge.components.Label("NOME", "NOME", this );
            NOME__7.setType( com.codecharge.components.ControlType.TEXT );
            NOME__7.setHtmlEncode( true );
            AD4_UTENTE.add(NOME__7);

            com.codecharge.components.Label SESSO__8 = new com.codecharge.components.Label("SESSO", "SESSO", this );
            SESSO__8.setType( com.codecharge.components.ControlType.TEXT );
            SESSO__8.setHtmlEncode( true );
            AD4_UTENTE.add(SESSO__8);

            com.codecharge.components.Label CODICE_FISCALE__38 = new com.codecharge.components.Label("CODICE_FISCALE", "CODICE_FISCALE", this );
            CODICE_FISCALE__38.setType( com.codecharge.components.ControlType.TEXT );
            CODICE_FISCALE__38.setHtmlEncode( true );
            AD4_UTENTE.add(CODICE_FISCALE__38);

            com.codecharge.components.Label DATA_NASCITA__10 = new com.codecharge.components.Label("DATA_NASCITA", "DATA_NASCITA", this );
            DATA_NASCITA__10.setType( com.codecharge.components.ControlType.TEXT );
            DATA_NASCITA__10.setHtmlEncode( true );
            AD4_UTENTE.add(DATA_NASCITA__10);

            com.codecharge.components.Label DES_COMUNE_NAS__11 = new com.codecharge.components.Label("DES_COMUNE_NAS", "DES_COMUNE_NAS", this );
            DES_COMUNE_NAS__11.setType( com.codecharge.components.ControlType.TEXT );
            DES_COMUNE_NAS__11.setHtmlEncode( true );
            AD4_UTENTE.add(DES_COMUNE_NAS__11);

            com.codecharge.components.Label DES_PROVINCIA_NAS__12 = new com.codecharge.components.Label("DES_PROVINCIA_NAS", "DES_PROVINCIA_NAS", this );
            DES_PROVINCIA_NAS__12.setType( com.codecharge.components.ControlType.TEXT );
            DES_PROVINCIA_NAS__12.setHtmlEncode( true );
            AD4_UTENTE.add(DES_PROVINCIA_NAS__12);

            com.codecharge.components.Label INDIRIZZO_COMPLETO__50 = new com.codecharge.components.Label("INDIRIZZO_COMPLETO", "INDIRIZZO_COMPLETO", this );
            INDIRIZZO_COMPLETO__50.setType( com.codecharge.components.ControlType.TEXT );
            INDIRIZZO_COMPLETO__50.setHtmlEncode( true );
            AD4_UTENTE.add(INDIRIZZO_COMPLETO__50);

            com.codecharge.components.Button Button_Update__24 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__24.addExcludeParam( "ccsForm" );
            Button_Update__24.addExcludeParam( "Button_Update" );
            Button_Update__24.setOperation( "Search" );
            AD4_UTENTE.add( Button_Update__24 );

            com.codecharge.components.Hidden MVPAGES__51 = new com.codecharge.components.Hidden("MVPAGES", "MVPAGES", this );
            MVPAGES__51.setType( com.codecharge.components.ControlType.TEXT );
            MVPAGES__51.setHtmlEncode( true );
            AD4_UTENTE.add( MVPAGES__51 );
            add(AD4_UTENTE);
        } // End definition of AD4_UTENTE record model.
//End AD4_UTENTE record

//AD4_SOGGETTO record @52-8F3AA6A7
        
        /*
            Model of AD4_SOGGETTO record defining.
        */
        {
            com.codecharge.components.Record AD4_SOGGETTO = new com.codecharge.components.Record("AD4_SOGGETTO");
            AD4_SOGGETTO.setPageModel( this );
            AD4_SOGGETTO.addExcludeParam( "ccsForm" );
            AD4_SOGGETTO.setVisible( true );
            AD4_SOGGETTO.setAllowDelete(false);
            AD4_SOGGETTO.setPreserveType(PreserveParameterType.NONE);
            AD4_SOGGETTO.setReturnPage("AmvUtenteDatiInfo" + Names.ACTION_SUFFIX);
            AD4_SOGGETTO.addRecordListener(new AD4_SOGGETTORecordHandler());

            com.codecharge.components.TextBox COGNOME__54 = new com.codecharge.components.TextBox("COGNOME", "UTENTE", this );
            COGNOME__54.setType( com.codecharge.components.ControlType.TEXT );
            COGNOME__54.setHtmlEncode( true );
            COGNOME__54.setCaption( "COGNOME" );
            AD4_SOGGETTO.add( COGNOME__54 );

            com.codecharge.components.TextBox NOME__55 = new com.codecharge.components.TextBox("NOME", "SOGGETTO", this );
            NOME__55.setType( com.codecharge.components.ControlType.TEXT );
            NOME__55.setHtmlEncode( true );
            NOME__55.setCaption( "NOME" );
            AD4_SOGGETTO.add( NOME__55 );

            com.codecharge.components.ListBox SESSO__56 = new com.codecharge.components.ListBox("SESSO", "", this );
            SESSO__56.setType( com.codecharge.components.ControlType.TEXT );
            SESSO__56.setHtmlEncode( true );
            SESSO__56.setCaption( "SESSO" );
            AD4_SOGGETTO.add( SESSO__56 );

            com.codecharge.components.TextBox DATA_NASCITA__57 = new com.codecharge.components.TextBox("DATA_NASCITA", "", this );
            DATA_NASCITA__57.setType( com.codecharge.components.ControlType.DATE );
            DATA_NASCITA__57.setHtmlEncode( true );
            DATA_NASCITA__57.setFormatPattern( "dd/MM/yyyy" );
            DATA_NASCITA__57.setCaption( "DATA_NASCITA" );
            AD4_SOGGETTO.add( DATA_NASCITA__57 );

            com.codecharge.components.ListBox STATO_NASCITA__58 = new com.codecharge.components.ListBox("STATO_NASCITA", "", this );
            STATO_NASCITA__58.setType( com.codecharge.components.ControlType.INTEGER );
            STATO_NASCITA__58.setHtmlEncode( true );
            STATO_NASCITA__58.setCaption( "STATO_NASCITA" );
            STATO_NASCITA__58.setBoundColumn( "STATO_TERRITORIO" );
            STATO_NASCITA__58.setTextColumn( "DENOMINAZIONE" );
            AD4_SOGGETTO.add( STATO_NASCITA__58 );

            com.codecharge.components.ListBox PROVINCIA_NASCITA__60 = new com.codecharge.components.ListBox("PROVINCIA_NASCITA", "", this );
            PROVINCIA_NASCITA__60.setType( com.codecharge.components.ControlType.INTEGER );
            PROVINCIA_NASCITA__60.setHtmlEncode( true );
            PROVINCIA_NASCITA__60.setCaption( "PROVINCIA_NASCITA" );
            PROVINCIA_NASCITA__60.setBoundColumn( "PROVINCIA" );
            PROVINCIA_NASCITA__60.setTextColumn( "DENOMINAZIONE" );
            AD4_SOGGETTO.add( PROVINCIA_NASCITA__60 );

            com.codecharge.components.ListBox COMUNE_NASCITA__63 = new com.codecharge.components.ListBox("COMUNE_NASCITA", "", this );
            COMUNE_NASCITA__63.setType( com.codecharge.components.ControlType.INTEGER );
            COMUNE_NASCITA__63.setHtmlEncode( true );
            COMUNE_NASCITA__63.setCaption( "COMUNE_NASCITA" );
            COMUNE_NASCITA__63.setBoundColumn( "COMUNE" );
            COMUNE_NASCITA__63.setTextColumn( "DENOMINAZIONE" );
            AD4_SOGGETTO.add( COMUNE_NASCITA__63 );

            com.codecharge.components.TextBox CODICE_FISCALE__67 = new com.codecharge.components.TextBox("CODICE_FISCALE", "", this );
            CODICE_FISCALE__67.setType( com.codecharge.components.ControlType.TEXT );
            CODICE_FISCALE__67.setHtmlEncode( true );
            CODICE_FISCALE__67.setCaption( "CODICE_FISCALE" );
            AD4_SOGGETTO.add( CODICE_FISCALE__67 );

            com.codecharge.components.Button Update__68 = new com.codecharge.components.Button("Update", this);
            Update__68.addExcludeParam( "ccsForm" );
            Update__68.addExcludeParam( "Update" );
            Update__68.setOperation( "Update" );
            AD4_SOGGETTO.add( Update__68 );

            com.codecharge.components.Button Insert__69 = new com.codecharge.components.Button("Insert", this);
            Insert__69.addExcludeParam( "ccsForm" );
            Insert__69.addExcludeParam( "Insert" );
            Insert__69.setOperation( "Insert" );
            AD4_SOGGETTO.add( Insert__69 );
            add(AD4_SOGGETTO);
        } // End definition of AD4_SOGGETTO record model.
//End AD4_SOGGETTO record

//AmvUtenteDatiInfoModel class tail @1-F5FC18C5
    }
}
//End AmvUtenteDatiInfoModel class tail

