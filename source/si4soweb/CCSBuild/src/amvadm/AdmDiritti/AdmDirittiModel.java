//AdmDirittiModel imports @1-543DE679
package amvadm.AdmDiritti;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmDirittiModel imports

//AdmDirittiModel class head @1-1B3DFBBF
public class AdmDirittiModel extends com.codecharge.components.Page {
    public AdmDirittiModel() {
        this( new CCSLocale(), null );
    }

    public AdmDirittiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmDirittiModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmDirittiModel class head

//page settings @1-96163641
        super("AdmDiritti", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__28 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__28.setVisible( true );
            add( Guida__28 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VISTA_DOCUMENTISearch record @31-74446AF7
        
        /*
            Model of AMV_VISTA_DOCUMENTISearch record defining.
        */
        {
            com.codecharge.components.Record AMV_VISTA_DOCUMENTISearch = new com.codecharge.components.Record("AMV_VISTA_DOCUMENTISearch");
            AMV_VISTA_DOCUMENTISearch.setPageModel( this );
            AMV_VISTA_DOCUMENTISearch.addExcludeParam( "ccsForm" );
            AMV_VISTA_DOCUMENTISearch.addExcludeParam( "MVTD" );
            AMV_VISTA_DOCUMENTISearch.setVisible( true );
            AMV_VISTA_DOCUMENTISearch.setAllowInsert(false);
            AMV_VISTA_DOCUMENTISearch.setAllowUpdate(false);
            AMV_VISTA_DOCUMENTISearch.setAllowDelete(false);
            AMV_VISTA_DOCUMENTISearch.setPreserveType(PreserveParameterType.GET);
            AMV_VISTA_DOCUMENTISearch.setReturnPage("AdmDiritti" + Names.ACTION_SUFFIX);

            com.codecharge.components.ListBox s_AREA__47 = new com.codecharge.components.ListBox("s_AREA", "AREA", this );
            s_AREA__47.setType( com.codecharge.components.ControlType.INTEGER );
            s_AREA__47.setHtmlEncode( true );
            s_AREA__47.setCaption( "ID AREA" );
            s_AREA__47.setBoundColumn( "ID_AREA" );
            s_AREA__47.setTextColumn( "NOME" );
            s_AREA__47.addValidateHandler( new RequiredHandler( "Il valore nel campo ID AREA è richiesto." ) );
            AMV_VISTA_DOCUMENTISearch.add( s_AREA__47 );

            com.codecharge.components.ListBox s_GRUPPO__45 = new com.codecharge.components.ListBox("s_GRUPPO", "GRUPPO", this );
            s_GRUPPO__45.setType( com.codecharge.components.ControlType.TEXT );
            s_GRUPPO__45.setHtmlEncode( true );
            s_GRUPPO__45.setCaption( "GRUPPO" );
            s_GRUPPO__45.setBoundColumn( "UTENTE" );
            s_GRUPPO__45.setTextColumn( "NOMINATIVO" );
            AMV_VISTA_DOCUMENTISearch.add( s_GRUPPO__45 );

            com.codecharge.components.ListBox s_DISPLAY__34 = new com.codecharge.components.ListBox("s_DISPLAY", "", this );
            s_DISPLAY__34.setType( com.codecharge.components.ControlType.TEXT );
            s_DISPLAY__34.setHtmlEncode( true );
            AMV_VISTA_DOCUMENTISearch.add( s_DISPLAY__34 );

            com.codecharge.components.Button DoSearch__40 = new com.codecharge.components.Button("DoSearch", this);
            DoSearch__40.addExcludeParam( "ccsForm" );
            DoSearch__40.addExcludeParam( "DoSearch" );
            DoSearch__40.setOperation( "Search" );
            AMV_VISTA_DOCUMENTISearch.add( DoSearch__40 );
            add(AMV_VISTA_DOCUMENTISearch);
        } // End definition of AMV_VISTA_DOCUMENTISearch record model.
//End AMV_VISTA_DOCUMENTISearch record

//AMV_DIRITTI grid @5-4FC2615C
        
        /*
            // Begin definition of AMV_DIRITTI grid model.
        */
        {
            com.codecharge.components.Grid AMV_DIRITTI = new com.codecharge.components.Grid("AMV_DIRITTI");
            AMV_DIRITTI.setPageModel( this );
            AMV_DIRITTI.setFetchSize(10);
            AMV_DIRITTI.setVisible( true );
            AMV_DIRITTI.addGridListener( new AMV_DIRITTIGridHandler() );

            com.codecharge.components.Label HEADER_AREA__50 = new com.codecharge.components.Label("HEADER_AREA", "HEADER_AREA", this );
            HEADER_AREA__50.setType( com.codecharge.components.ControlType.TEXT );
            HEADER_AREA__50.setHtmlEncode( true );
            AMV_DIRITTI.add(HEADER_AREA__50);

            com.codecharge.components.Label GRUPPO__11 = new com.codecharge.components.Label("GRUPPO", "GRUPPO", this );
            GRUPPO__11.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPO__11.setHtmlEncode( true );
            AMV_DIRITTI.add(GRUPPO__11);

            com.codecharge.components.Label NOME_TIPOLOGIA__13 = new com.codecharge.components.Label("NOME_TIPOLOGIA", "NOME_TIPOLOGIA", this );
            NOME_TIPOLOGIA__13.setType( com.codecharge.components.ControlType.TEXT );
            NOME_TIPOLOGIA__13.setHtmlEncode( true );
            AMV_DIRITTI.add(NOME_TIPOLOGIA__13);

            com.codecharge.components.Label ACCESSO__12 = new com.codecharge.components.Label("ACCESSO", "ACCESSO", this );
            ACCESSO__12.setType( com.codecharge.components.ControlType.TEXT );
            ACCESSO__12.setHtmlEncode( true );
            AMV_DIRITTI.add(ACCESSO__12);

            com.codecharge.components.Link Edit__26 = new com.codecharge.components.Link("Edit", "EDIT", this );
            Edit__26.setType( com.codecharge.components.ControlType.TEXT );
            Edit__26.setHtmlEncode( true );
            Edit__26.setHrefSourceValue( "AdmDiritti" + Names.ACTION_SUFFIX );
            Edit__26.setHrefType( "Page" );
            Edit__26.setConvertRule("Relative");
            Edit__26.setPreserveType(PreserveParameterType.GET);
            Edit__26.addParameter( new LinkParameter( "ID", "ID_DIRITTO", ParameterSource.DATAFIELD) );
            AMV_DIRITTI.add( Edit__26 );

            com.codecharge.components.Label AFCNavigator__30 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__30.setType( com.codecharge.components.ControlType.TEXT );
            AMV_DIRITTI.add(AFCNavigator__30);
            add(AMV_DIRITTI);
        } // End definition of AMV_DIRITTI grid model
//End AMV_DIRITTI grid

//AMV_DIRITTI1 record @15-EFD2DCF1
        
        /*
            Model of AMV_DIRITTI1 record defining.
        */
        {
            com.codecharge.components.Record AMV_DIRITTI1 = new com.codecharge.components.Record("AMV_DIRITTI1");
            AMV_DIRITTI1.setPageModel( this );
            AMV_DIRITTI1.addExcludeParam( "ccsForm" );
            AMV_DIRITTI1.setVisible( true );
            AMV_DIRITTI1.setPreserveType(PreserveParameterType.NONE);
            AMV_DIRITTI1.setReturnPage("AdmDiritti" + Names.ACTION_SUFFIX);

            com.codecharge.components.ListBox ID_AREA__22 = new com.codecharge.components.ListBox("ID_AREA", "ID_AREA", this );
            ID_AREA__22.setType( com.codecharge.components.ControlType.INTEGER );
            ID_AREA__22.setHtmlEncode( true );
            ID_AREA__22.setCaption( "ID AREA" );
            ID_AREA__22.setBoundColumn( "ID_AREA" );
            ID_AREA__22.setTextColumn( "NOME" );
            ID_AREA__22.addValidateHandler( new RequiredHandler( "Il valore nel campo ID AREA è richiesto." ) );
            AMV_DIRITTI1.add( ID_AREA__22 );

            com.codecharge.components.ListBox ID_TIPOLOGIA__25 = new com.codecharge.components.ListBox("ID_TIPOLOGIA", "ID_TIPOLOGIA", this );
            ID_TIPOLOGIA__25.setType( com.codecharge.components.ControlType.INTEGER );
            ID_TIPOLOGIA__25.setHtmlEncode( true );
            ID_TIPOLOGIA__25.setCaption( "ID TIPOLOGIA" );
            ID_TIPOLOGIA__25.setBoundColumn( "ID_TIPOLOGIA" );
            ID_TIPOLOGIA__25.setTextColumn( "NOME" );
            AMV_DIRITTI1.add( ID_TIPOLOGIA__25 );

            com.codecharge.components.ListBox GRUPPO__23 = new com.codecharge.components.ListBox("GRUPPO", "GRUPPO", this );
            GRUPPO__23.setType( com.codecharge.components.ControlType.TEXT );
            GRUPPO__23.setHtmlEncode( true );
            GRUPPO__23.setCaption( "GRUPPO" );
            GRUPPO__23.setBoundColumn( "UTENTE" );
            GRUPPO__23.setTextColumn( "NOMINATIVO" );
            AMV_DIRITTI1.add( GRUPPO__23 );

            com.codecharge.components.ListBox ACCESSO__24 = new com.codecharge.components.ListBox("ACCESSO", "ACCESSO", this );
            ACCESSO__24.setType( com.codecharge.components.ControlType.TEXT );
            ACCESSO__24.setHtmlEncode( true );
            ACCESSO__24.setCaption( "ACCESSO" );
            ACCESSO__24.addValidateHandler( new RequiredHandler( "Il valore nel campo ACCESSO è richiesto." ) );
            AMV_DIRITTI1.add( ACCESSO__24 );

            com.codecharge.components.Button Insert__16 = new com.codecharge.components.Button("Insert", this);
            Insert__16.addExcludeParam( "ccsForm" );
            Insert__16.addExcludeParam( "Insert" );
            Insert__16.setOperation( "Insert" );
            AMV_DIRITTI1.add( Insert__16 );

            com.codecharge.components.Button Update__17 = new com.codecharge.components.Button("Update", this);
            Update__17.addExcludeParam( "ccsForm" );
            Update__17.addExcludeParam( "Update" );
            Update__17.setOperation( "Update" );
            AMV_DIRITTI1.add( Update__17 );

            com.codecharge.components.Button Delete__18 = new com.codecharge.components.Button("Delete", this);
            Delete__18.addExcludeParam( "ccsForm" );
            Delete__18.addExcludeParam( "Delete" );
            Delete__18.setOperation( "Delete" );
            AMV_DIRITTI1.add( Delete__18 );

            com.codecharge.components.Button Cancel__19 = new com.codecharge.components.Button("Cancel", this);
            Cancel__19.addExcludeParam( "ccsForm" );
            Cancel__19.addExcludeParam( "Cancel" );
            Cancel__19.setOperation( "Cancel" );
            AMV_DIRITTI1.add( Cancel__19 );

            com.codecharge.components.Hidden ID_DIRITTO__21 = new com.codecharge.components.Hidden("ID_DIRITTO", "ID_DIRITTO", this );
            ID_DIRITTO__21.setType( com.codecharge.components.ControlType.INTEGER );
            ID_DIRITTO__21.setHtmlEncode( true );
            ID_DIRITTO__21.setCaption( "ID DIRITTO" );
            AMV_DIRITTI1.add( ID_DIRITTO__21 );
            add(AMV_DIRITTI1);
        } // End definition of AMV_DIRITTI1 record model.
//End AMV_DIRITTI1 record

//AdmDirittiModel class tail @1-F5FC18C5
    }
}
//End AdmDirittiModel class tail

