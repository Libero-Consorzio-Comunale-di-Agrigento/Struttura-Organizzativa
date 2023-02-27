//AdmArgomentiModel imports @1-A3D0BC29
package amvadm.AdmArgomenti;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmArgomentiModel imports

//AdmArgomentiModel class head @1-12D9374B
public class AdmArgomentiModel extends com.codecharge.components.Page {
    public AdmArgomentiModel() {
        this( new CCSLocale(), null );
    }

    public AdmArgomentiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmArgomentiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmArgomentiModel class head

//page settings @1-2380EF98
        super("AdmArgomenti", locale );
        setResponse(response);
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

//AMV_ARGOMENTI grid @5-2885C55B
        
        /*
            // Begin definition of AMV_ARGOMENTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_ARGOMENTI = new com.codecharge.components.Grid("AMV_ARGOMENTI");
            AMV_ARGOMENTI.setPageModel( this );
            AMV_ARGOMENTI.setFetchSize(10);
            AMV_ARGOMENTI.setVisible( true );
            AMV_ARGOMENTI.addGridListener( new AMV_ARGOMENTIGridHandler() );
            com.codecharge.components.Sorter Sorter_NOME = new com.codecharge.components.Sorter("Sorter_NOME", AMV_ARGOMENTI, this);
            Sorter_NOME.setColumn("NOME");
            AMV_ARGOMENTI.add(Sorter_NOME);
            com.codecharge.components.Sorter Descrizione = new com.codecharge.components.Sorter("Descrizione", AMV_ARGOMENTI, this);
            Descrizione.setColumn("DESCRIZIONE");
            AMV_ARGOMENTI.add(Descrizione);

            com.codecharge.components.Link NOME__9 = new com.codecharge.components.Link("NOME", "NOME", this );
            NOME__9.setType( com.codecharge.components.ControlType.TEXT );
            NOME__9.setHtmlEncode( true );
            NOME__9.setHrefSourceValue( "AdmArgomenti" + Names.ACTION_SUFFIX );
            NOME__9.setHrefType( "Page" );
            NOME__9.setConvertRule("Relative");
            NOME__9.setPreserveType(PreserveParameterType.GET);
            NOME__9.addParameter( new LinkParameter( "ID", "ID_ARGOMENTO", ParameterSource.DATAFIELD) );
            AMV_ARGOMENTI.add( NOME__9 );

            com.codecharge.components.Label DESCRIZIONE__25 = new com.codecharge.components.Label("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__25.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__25.setHtmlEncode( true );
            AMV_ARGOMENTI.add(DESCRIZIONE__25);

            com.codecharge.components.Label AFCNavigator__27 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__27.setType( com.codecharge.components.ControlType.TEXT );
            AMV_ARGOMENTI.add(AFCNavigator__27);
            add(AMV_ARGOMENTI);
        } // End definition of AMV_ARGOMENTI grid model
//End AMV_ARGOMENTI grid

//AMV_ARGOMENTI1 record @14-D77706E0
        
        /*
            Model of AMV_ARGOMENTI1 record defining.
        */
        {
            com.codecharge.components.Record AMV_ARGOMENTI1 = new com.codecharge.components.Record("AMV_ARGOMENTI1");
            AMV_ARGOMENTI1.setPageModel( this );
            AMV_ARGOMENTI1.addExcludeParam( "ccsForm" );
            AMV_ARGOMENTI1.setVisible( true );
            AMV_ARGOMENTI1.setPreserveType(PreserveParameterType.NONE);
            AMV_ARGOMENTI1.setReturnPage("AdmArgomenti" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__21 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__21.setType( com.codecharge.components.ControlType.TEXT );
            NOME__21.setHtmlEncode( true );
            NOME__21.setCaption( "NOME" );
            NOME__21.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_ARGOMENTI1.add( NOME__21 );

            com.codecharge.components.TextArea DESCRIZIONE__23 = new com.codecharge.components.TextArea("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__23.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__23.setHtmlEncode( true );
            DESCRIZIONE__23.setCaption( "DESCRIZIONE" );
            AMV_ARGOMENTI1.add( DESCRIZIONE__23 );

            com.codecharge.components.Button Insert__15 = new com.codecharge.components.Button("Insert", this);
            Insert__15.addExcludeParam( "ccsForm" );
            Insert__15.addExcludeParam( "Insert" );
            Insert__15.setOperation( "Insert" );
            AMV_ARGOMENTI1.add( Insert__15 );

            com.codecharge.components.Button Update__16 = new com.codecharge.components.Button("Update", this);
            Update__16.addExcludeParam( "ccsForm" );
            Update__16.addExcludeParam( "Update" );
            Update__16.setOperation( "Update" );
            AMV_ARGOMENTI1.add( Update__16 );

            com.codecharge.components.Button Delete__17 = new com.codecharge.components.Button("Delete", this);
            Delete__17.addExcludeParam( "ccsForm" );
            Delete__17.addExcludeParam( "Delete" );
            Delete__17.setOperation( "Delete" );
            AMV_ARGOMENTI1.add( Delete__17 );

            com.codecharge.components.Button Cancel__18 = new com.codecharge.components.Button("Cancel", this);
            Cancel__18.addExcludeParam( "ccsForm" );
            Cancel__18.addExcludeParam( "Cancel" );
            Cancel__18.setOperation( "Cancel" );
            AMV_ARGOMENTI1.add( Cancel__18 );

            com.codecharge.components.Hidden ID_ARGOMENTO__20 = new com.codecharge.components.Hidden("ID_ARGOMENTO", "ID_ARGOMENTO", this );
            ID_ARGOMENTO__20.setType( com.codecharge.components.ControlType.INTEGER );
            ID_ARGOMENTO__20.setHtmlEncode( true );
            ID_ARGOMENTO__20.setCaption( "ID ARGOMENTO" );
            AMV_ARGOMENTI1.add( ID_ARGOMENTO__20 );
            add(AMV_ARGOMENTI1);
        } // End definition of AMV_ARGOMENTI1 record model.
//End AMV_ARGOMENTI1 record

//AdmArgomentiModel class tail @1-F5FC18C5
    }
}
//End AdmArgomentiModel class tail

