//AdmAccessiModel imports @1-26FEDD1E
package amvadm.AdmAccessi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmAccessiModel imports

//AdmAccessiModel class head @1-38D642F5
public class AdmAccessiModel extends com.codecharge.components.Page {
    public AdmAccessiModel() {
        this( new CCSLocale(), null );
    }

    public AdmAccessiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmAccessiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmAccessiModel class head

//page settings @1-3D79BBD5
        super("AdmAccessi", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__26 = new com.codecharge.components.IncludePage("Header", this );
            Header__26.setVisible( true );
            add( Header__26 );
            com.codecharge.components.IncludePage Left__27 = new com.codecharge.components.IncludePage("Left", this );
            Left__27.setVisible( true );
            add( Left__27 );
            com.codecharge.components.IncludePage Guida__29 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__29.setVisible( true );
            add( Guida__29 );
            com.codecharge.components.IncludePage Footer__28 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__28.setVisible( true );
            add( Footer__28 );
        } // end page
//End page settings

//AD4_ACCESSISearch record @30-D35DFEDC
        
        /*
            Model of AD4_ACCESSISearch record defining.
        */
        {
            com.codecharge.components.Record AD4_ACCESSISearch = new com.codecharge.components.Record("AD4_ACCESSISearch");
            AD4_ACCESSISearch.setPageModel( this );
            AD4_ACCESSISearch.addExcludeParam( "ccsForm" );
            AD4_ACCESSISearch.setVisible( true );
            AD4_ACCESSISearch.setAllowInsert(false);
            AD4_ACCESSISearch.setAllowUpdate(false);
            AD4_ACCESSISearch.setAllowDelete(false);
            AD4_ACCESSISearch.setPreserveType(PreserveParameterType.GET);
            AD4_ACCESSISearch.setReturnPage("AdmAccessi" + Names.ACTION_SUFFIX);
            AD4_ACCESSISearch.addRecordListener(new AD4_ACCESSISearchRecordHandler());

            com.codecharge.components.TextBox DAL__36 = new com.codecharge.components.TextBox("DAL", "", this );
            DAL__36.setType( com.codecharge.components.ControlType.DATE );
            DAL__36.setHtmlEncode( true );
            DAL__36.setFormatPattern( "dd/MM/yyyy" );
            DAL__36.setCaption( "DAL" );
            AD4_ACCESSISearch.add( DAL__36 );
            com.codecharge.components.DatePicker DatePicker1__53 = new com.codecharge.components.DatePicker("DatePicker1", this);
            DatePicker1__53.setControlName("DAL");
            DatePicker1__53.setStyleName("../Themes/AFC/Style.css");
            AD4_ACCESSISearch.add(DatePicker1__53);

            com.codecharge.components.TextBox AL__37 = new com.codecharge.components.TextBox("AL", "", this );
            AL__37.setType( com.codecharge.components.ControlType.DATE );
            AL__37.setHtmlEncode( true );
            AL__37.setFormatPattern( "dd/MM/yyyy" );
            AL__37.setCaption( "AL" );
            AD4_ACCESSISearch.add( AL__37 );
            com.codecharge.components.DatePicker DatePicker2__54 = new com.codecharge.components.DatePicker("DatePicker2", this);
            DatePicker2__54.setControlName("AL");
            DatePicker2__54.setStyleName("../Themes/AFC/Style.css");
            AD4_ACCESSISearch.add(DatePicker2__54);

            com.codecharge.components.Button DoSearch__34 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__34.addExcludeParam( "ccsForm" );
            DoSearch__34.addExcludeParam( "DoSearch" );
            DoSearch__34.setOperation( "Search" );
            AD4_ACCESSISearch.add( DoSearch__34 );

            com.codecharge.components.ListBox SM__38 = new com.codecharge.components.ListBox("SM", "", this );
            SM__38.setType( com.codecharge.components.ControlType.TEXT );
            SM__38.setHtmlEncode( true );
            SM__38.setBoundColumn( "MODULO" );
            SM__38.setTextColumn( "DESCRIZIONE" );
            AD4_ACCESSISearch.add( SM__38 );
            add(AD4_ACCESSISearch);
        } // End definition of AD4_ACCESSISearch record model.
//End AD4_ACCESSISearch record

//AccessiDettaglio grid @41-C67CB383
        
        /*
            // Begin definition of AccessiDettaglio grid model.
        */
        {
            com.codecharge.components.Grid AccessiDettaglio = new com.codecharge.components.Grid("AccessiDettaglio");
            AccessiDettaglio.setPageModel( this );
            AccessiDettaglio.setFetchSize(20);
            AccessiDettaglio.setVisible( true );
            AccessiDettaglio.addGridListener( new AccessiDettaglioGridHandler() );
            com.codecharge.components.Sorter Sorter_ACCESSO = new com.codecharge.components.Sorter("Sorter_ACCESSO", AccessiDettaglio, this);
            Sorter_ACCESSO.setColumn("DATA_ACCESSO");
            AccessiDettaglio.add(Sorter_ACCESSO);
            com.codecharge.components.Sorter Sorter_NOMINATIVO = new com.codecharge.components.Sorter("Sorter_NOMINATIVO", AccessiDettaglio, this);
            Sorter_NOMINATIVO.setColumn("NOMINATIVO");
            AccessiDettaglio.add(Sorter_NOMINATIVO);

            com.codecharge.components.Label DATA_ACCESSO__43 = new com.codecharge.components.Label("DATA_ACCESSO", "DATA_ACCESSO", this );
            DATA_ACCESSO__43.setType( com.codecharge.components.ControlType.DATE );
            DATA_ACCESSO__43.setHtmlEncode( true );
            DATA_ACCESSO__43.setFormatPattern( "dd/MM/yyyy H:mm:ss" );
            AccessiDettaglio.add(DATA_ACCESSO__43);

            com.codecharge.components.Link NOMINATIVO__55 = new com.codecharge.components.Link("NOMINATIVO", "NOMINATIVO", this );
            NOMINATIVO__55.setType( com.codecharge.components.ControlType.TEXT );
            NOMINATIVO__55.setHtmlEncode( true );
            NOMINATIVO__55.setHrefSourceValue( "AdmUtenteDatiInfo" + Names.ACTION_SUFFIX );
            NOMINATIVO__55.setHrefType( "Page" );
            NOMINATIVO__55.setConvertRule("Relative");
            NOMINATIVO__55.setPreserveType(PreserveParameterType.NONE);
            NOMINATIVO__55.addParameter( new LinkParameter( "IDUTE", "UTENTE", ParameterSource.DATAFIELD) );
            NOMINATIVO__55.addParameter( new LinkParameter( "MVVC", "", ParameterSource.EXPRESSION) );
            AccessiDettaglio.add( NOMINATIVO__55 );

            com.codecharge.components.Label SESSIONE__44 = new com.codecharge.components.Label("SESSIONE", "SESSIONE", this );
            SESSIONE__44.setType( com.codecharge.components.ControlType.TEXT );
            AccessiDettaglio.add(SESSIONE__44);

            com.codecharge.components.Label AFCNavigator__45 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__45.setType( com.codecharge.components.ControlType.TEXT );
            AccessiDettaglio.add(AFCNavigator__45);
            add(AccessiDettaglio);
        } // End definition of AccessiDettaglio grid model
//End AccessiDettaglio grid

//AdmAccessiModel class tail @1-F5FC18C5
    }
}
//End AdmAccessiModel class tail


