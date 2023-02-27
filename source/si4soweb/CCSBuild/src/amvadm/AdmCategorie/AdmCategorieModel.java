//AdmCategorieModel imports @1-16EE05CF
package amvadm.AdmCategorie;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmCategorieModel imports

//AdmCategorieModel class head @1-8772A58F
public class AdmCategorieModel extends com.codecharge.components.Page {
    public AdmCategorieModel() {
        this( new CCSLocale(), null );
    }

    public AdmCategorieModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmCategorieModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmCategorieModel class head

//page settings @1-66C164D8
        super("AdmCategorie", locale );
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

//AMV_CATEGORIE grid @2-3D57E9A2
        
        /*
            // Begin definition of AMV_CATEGORIE grid model.
        */
        {
            com.codecharge.components.Grid AMV_CATEGORIE = new com.codecharge.components.Grid("AMV_CATEGORIE");
            AMV_CATEGORIE.setPageModel( this );
            AMV_CATEGORIE.setFetchSize(10);
            AMV_CATEGORIE.setVisible( true );
            AMV_CATEGORIE.addGridListener( new AMV_CATEGORIEGridHandler() );
            com.codecharge.components.Sorter Sorter_NOME = new com.codecharge.components.Sorter("Sorter_NOME", AMV_CATEGORIE, this);
            Sorter_NOME.setColumn("NOME");
            AMV_CATEGORIE.add(Sorter_NOME);
            com.codecharge.components.Sorter Sorter_DESCRIZIONE = new com.codecharge.components.Sorter("Sorter_DESCRIZIONE", AMV_CATEGORIE, this);
            Sorter_DESCRIZIONE.setColumn("DESCRIZIONE");
            AMV_CATEGORIE.add(Sorter_DESCRIZIONE);

            com.codecharge.components.Link NOME__6 = new com.codecharge.components.Link("NOME", "NOME", this );
            NOME__6.setType( com.codecharge.components.ControlType.TEXT );
            NOME__6.setHtmlEncode( true );
            NOME__6.setHrefSourceValue( "AdmCategorie" + Names.ACTION_SUFFIX );
            NOME__6.setHrefType( "Page" );
            NOME__6.setConvertRule("Relative");
            NOME__6.setPreserveType(PreserveParameterType.GET);
            NOME__6.addParameter( new LinkParameter( "ID", "ID_CATEGORIA", ParameterSource.DATAFIELD) );
            AMV_CATEGORIE.add( NOME__6 );

            com.codecharge.components.Label DESCRIZIONE__8 = new com.codecharge.components.Label("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__8.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__8.setHtmlEncode( true );
            AMV_CATEGORIE.add(DESCRIZIONE__8);

            com.codecharge.components.Label AFCNavigator__26 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__26.setType( com.codecharge.components.ControlType.TEXT );
            AMV_CATEGORIE.add(AFCNavigator__26);
            add(AMV_CATEGORIE);
        } // End definition of AMV_CATEGORIE grid model
//End AMV_CATEGORIE grid

//AMV_CATEGORIE1 record @11-4E306F3D
        
        /*
            Model of AMV_CATEGORIE1 record defining.
        */
        {
            com.codecharge.components.Record AMV_CATEGORIE1 = new com.codecharge.components.Record("AMV_CATEGORIE1");
            AMV_CATEGORIE1.setPageModel( this );
            AMV_CATEGORIE1.addExcludeParam( "ccsForm" );
            AMV_CATEGORIE1.setVisible( true );
            AMV_CATEGORIE1.setPreserveType(PreserveParameterType.NONE);
            AMV_CATEGORIE1.setReturnPage("AdmCategorie" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox NOME__13 = new com.codecharge.components.TextBox("NOME", "NOME", this );
            NOME__13.setType( com.codecharge.components.ControlType.TEXT );
            NOME__13.setHtmlEncode( true );
            NOME__13.setCaption( "NOME" );
            NOME__13.addValidateHandler( new RequiredHandler( "Il valore nel campo NOME è richiesto." ) );
            AMV_CATEGORIE1.add( NOME__13 );

            com.codecharge.components.TextArea DESCRIZIONE__15 = new com.codecharge.components.TextArea("DESCRIZIONE", "DESCRIZIONE", this );
            DESCRIZIONE__15.setType( com.codecharge.components.ControlType.TEXT );
            DESCRIZIONE__15.setHtmlEncode( true );
            DESCRIZIONE__15.setCaption( "SEQUENZA" );
            AMV_CATEGORIE1.add( DESCRIZIONE__15 );

            com.codecharge.components.Button Insert__16 = new com.codecharge.components.Button("Insert", this);
            Insert__16.addExcludeParam( "ccsForm" );
            Insert__16.addExcludeParam( "Insert" );
            Insert__16.setOperation( "Insert" );
            AMV_CATEGORIE1.add( Insert__16 );

            com.codecharge.components.Button Update__17 = new com.codecharge.components.Button("Update", this);
            Update__17.addExcludeParam( "ccsForm" );
            Update__17.addExcludeParam( "Update" );
            Update__17.setOperation( "Update" );
            AMV_CATEGORIE1.add( Update__17 );

            com.codecharge.components.Button Delete__18 = new com.codecharge.components.Button("Delete", this);
            Delete__18.addExcludeParam( "ccsForm" );
            Delete__18.addExcludeParam( "Delete" );
            Delete__18.setOperation( "Delete" );
            AMV_CATEGORIE1.add( Delete__18 );

            com.codecharge.components.Button Cancel__19 = new com.codecharge.components.Button("Cancel", this);
            Cancel__19.addExcludeParam( "ccsForm" );
            Cancel__19.addExcludeParam( "Cancel" );
            Cancel__19.setOperation( "Cancel" );
            AMV_CATEGORIE1.add( Cancel__19 );

            com.codecharge.components.Hidden ID_CATEGORIA__20 = new com.codecharge.components.Hidden("ID_CATEGORIA", "ID_CATEGORIA", this );
            ID_CATEGORIA__20.setType( com.codecharge.components.ControlType.INTEGER );
            ID_CATEGORIA__20.setHtmlEncode( true );
            ID_CATEGORIA__20.setCaption( "ID_CATEGORIA" );
            AMV_CATEGORIE1.add( ID_CATEGORIA__20 );
            add(AMV_CATEGORIE1);
        } // End definition of AMV_CATEGORIE1 record model.
//End AMV_CATEGORIE1 record

//AdmCategorieModel class tail @1-F5FC18C5
    }
}
//End AdmCategorieModel class tail

