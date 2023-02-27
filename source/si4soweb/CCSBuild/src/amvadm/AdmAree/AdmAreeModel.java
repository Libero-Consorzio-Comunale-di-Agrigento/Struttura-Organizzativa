//AdmAreeModel imports @1-F783EF5C
package amvadm.AdmAree;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmAreeModel imports

//AdmAreeModel class head @1-34D3F265
public class AdmAreeModel extends com.codecharge.components.Page {
    public AdmAreeModel() {
        this( new CCSLocale(), null );
    }

    public AdmAreeModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmAreeModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmAreeModel class head

//page settings @1-A865CB91
        super("AdmAree", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__22 = new com.codecharge.components.IncludePage("Header", this );
            Header__22.setVisible( true );
            add( Header__22 );
            com.codecharge.components.IncludePage Left__23 = new com.codecharge.components.IncludePage("Left", this );
            Left__23.setVisible( true );
            add( Left__23 );
            com.codecharge.components.IncludePage Guida__25 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__25.setVisible( true );
            add( Guida__25 );
            com.codecharge.components.IncludePage Footer__24 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__24.setVisible( true );
            add( Footer__24 );
        } // end page
//End page settings

//AMV_AREE grid @2-9CE8514D
        
        /*
            // Begin definition of AMV_AREE grid model.
        */
        {
            com.codecharge.components.Grid AMV_AREE = new com.codecharge.components.Grid("AMV_AREE");
            AMV_AREE.setPageModel( this );
            AMV_AREE.setFetchSize(10);
            AMV_AREE.setVisible( true );
            AMV_AREE.addGridListener( new AMV_AREEGridHandler() );
            com.codecharge.components.Sorter Sorter_NOME = new com.codecharge.components.Sorter("Sorter_NOME", AMV_AREE, this);
            Sorter_NOME.setColumn("NOME");
            AMV_AREE.add(Sorter_NOME);
            com.codecharge.components.Sorter Sorter_DESCRIZIONE = new com.codecharge.components.Sorter("Sorter_DESCRIZIONE", AMV_AREE, this);
            Sorter_DESCRIZIONE.setColumn("DESCRIZIONE");
            AMV_AREE.add(Sorter_DESCRIZIONE);

            com.codecharge.components.Link NOME__6 = new com.codecharge.components.Link("NOME", "NOME", this );
            NOME__6.setType( com.codecharge.components.ControlType.TEXT );
            NOME__6.setHtmlEncode( true );
            NOME__6.setHrefSourceValue( "AdmAree" + Names.ACTION_SUFFIX );
            NOME__6.setHrefType( "Page" );
            NOME__6.setConvertRule("Relative");
            NOME__6.setPreserveType(PreserveParameterType.GET);
            NOME__6.addParameter( new LinkParameter( "ID", "ID_AREA", ParameterSource.DATAFIELD) );
            AMV_AREE.add( NOME__6 );

            com.codecharge.components.Label DESCRIZIONE__8 = new com.codecharge.components.Label("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__8.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__8.setHtmlEncode( true );
            AMV_AREE.add(DESCRIZIONE__8);

            com.codecharge.components.Label AFCNavigator__26 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__26.setType( com.codecharge.components.ControlType.TEXT );
            AMV_AREE.add(AFCNavigator__26);
            add(AMV_AREE);
        } // End definition of AMV_AREE grid model
//End AMV_AREE grid

//AMV_AREE1 record @11-E20D4058
        
        /*
            Model of AMV_AREE1 record defining.
        */
        {
            com.codecharge.components.Record AMV_AREE1 = new com.codecharge.components.Record("AMV_AREE1");
            AMV_AREE1.setPageModel( this );
            AMV_AREE1.addExcludeParam( "ccsForm" );
            AMV_AREE1.setVisible( true );
            AMV_AREE1.setPreserveType(PreserveParameterType.NONE);
            AMV_AREE1.setReturnPage("AdmAree" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__13 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__13.setType( com.codecharge.components.ControlType.TEXT );
            NOME__13.setHtmlEncode( true );
            NOME__13.setCaption( "NOME" );
            NOME__13.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_AREE1.add( NOME__13 );

            com.codecharge.components.TextArea DESCRIZIONE__15 = new com.codecharge.components.TextArea("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__15.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__15.setHtmlEncode( true );
            DESCRIZIONE__15.setCaption( "SEQUENZA" );
            AMV_AREE1.add( DESCRIZIONE__15 );

            com.codecharge.components.Button Insert__16 = new com.codecharge.components.Button("Insert", this);
            Insert__16.addExcludeParam( "ccsForm" );
            Insert__16.addExcludeParam( "Insert" );
            Insert__16.setOperation( "Insert" );
            AMV_AREE1.add( Insert__16 );

            com.codecharge.components.Button Update__17 = new com.codecharge.components.Button("Update", this);
            Update__17.addExcludeParam( "ccsForm" );
            Update__17.addExcludeParam( "Update" );
            Update__17.setOperation( "Update" );
            AMV_AREE1.add( Update__17 );

            com.codecharge.components.Button Delete__18 = new com.codecharge.components.Button("Delete", this);
            Delete__18.addExcludeParam( "ccsForm" );
            Delete__18.addExcludeParam( "Delete" );
            Delete__18.setOperation( "Delete" );
            AMV_AREE1.add( Delete__18 );

            com.codecharge.components.Button Cancel__19 = new com.codecharge.components.Button("Cancel", this);
            Cancel__19.addExcludeParam( "ccsForm" );
            Cancel__19.addExcludeParam( "Cancel" );
            Cancel__19.setOperation( "Cancel" );
            AMV_AREE1.add( Cancel__19 );

            com.codecharge.components.Hidden ID_AREA__20 = new com.codecharge.components.Hidden("ID_AREA", "ID_AREA", this );
            ID_AREA__20.setType( com.codecharge.components.ControlType.INTEGER );
            ID_AREA__20.setHtmlEncode( true );
            ID_AREA__20.setCaption( "ID_AREA" );
            AMV_AREE1.add( ID_AREA__20 );
            add(AMV_AREE1);
        } // End definition of AMV_AREE1 record model.
//End AMV_AREE1 record

//AdmAreeModel class tail @1-F5FC18C5
    }
}
//End AdmAreeModel class tail

