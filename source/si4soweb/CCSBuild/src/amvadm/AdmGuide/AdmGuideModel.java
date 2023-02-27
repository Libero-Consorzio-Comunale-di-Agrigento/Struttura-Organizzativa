//AdmGuideModel imports @1-C74DEC01
package amvadm.AdmGuide;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmGuideModel imports

//AdmGuideModel class head @1-92AB5602
public class AdmGuideModel extends com.codecharge.components.Page {
    public AdmGuideModel() {
        this( new CCSLocale(), null );
    }

    public AdmGuideModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmGuideModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmGuideModel class head

//page settings @1-3620236A
        super("AdmGuide", locale );
        setResponse(response);
        addPageListener(new AdmGuidePageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AMV_VOCI grid @41-F02E9F99
        
        /*
            // Begin definition of AMV_VOCI grid model.
        */
        {
            com.codecharge.components.Grid AMV_VOCI = new com.codecharge.components.Grid("AMV_VOCI");
            AMV_VOCI.setPageModel( this );
            AMV_VOCI.setFetchSize(10);
            AMV_VOCI.setVisible( true );

            com.codecharge.components.Label TITOLO_VOCE__42 = new com.codecharge.components.Label("TITOLO_VOCE", "TITOLO", this );
            TITOLO_VOCE__42.setType( com.codecharge.components.ControlType.TEXT );
            AMV_VOCI.add(TITOLO_VOCE__42);
            add(AMV_VOCI);
        } // End definition of AMV_VOCI grid model
//End AMV_VOCI grid

//AMV_GUIDE grid @5-780DF3DC
        
        /*
            // Begin definition of AMV_GUIDE grid model.
        */
        {
            com.codecharge.components.Grid AMV_GUIDE = new com.codecharge.components.Grid("AMV_GUIDE");
            AMV_GUIDE.setPageModel( this );
            AMV_GUIDE.setFetchSize(10);
            AMV_GUIDE.setVisible( true );
            AMV_GUIDE.addGridListener( new AMV_GUIDEGridHandler() );
            com.codecharge.components.Sorter Sorter_TITOLO = new com.codecharge.components.Sorter("Sorter_TITOLO", AMV_GUIDE, this);
            Sorter_TITOLO.setColumn("TITOLO");
            AMV_GUIDE.add(Sorter_TITOLO);
            com.codecharge.components.Sorter Sorter_SEQUENZA = new com.codecharge.components.Sorter("Sorter_SEQUENZA", AMV_GUIDE, this);
            Sorter_SEQUENZA.setColumn("SEQUENZA");
            AMV_GUIDE.add(Sorter_SEQUENZA);

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__10.setHtmlEncode( true );
            AMV_GUIDE.add(TITOLO__10);

            com.codecharge.components.Label SEQUENZA__11 = new com.codecharge.components.Label("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__11.setType( com.codecharge.components.ControlType.TEXT );
            SEQUENZA__11.setHtmlEncode( true );
            AMV_GUIDE.add(SEQUENZA__11);

            com.codecharge.components.Label VOCE_RIF__12 = new com.codecharge.components.Label("VOCE_RIF", "VOCE_RIF", this );
            VOCE_RIF__12.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_RIF__12.setHtmlEncode( true );
            AMV_GUIDE.add(VOCE_RIF__12);

            com.codecharge.components.Label URL_RIF__13 = new com.codecharge.components.Label("URL_RIF", "URL_RIF", this );
            URL_RIF__13.setType( com.codecharge.components.ControlType.TEXT );
            URL_RIF__13.setHtmlEncode( true );
            AMV_GUIDE.add(URL_RIF__13);

            com.codecharge.components.Link Modifica__14 = new com.codecharge.components.Link("Modifica", "MODIFICA", this );
            Modifica__14.setType( com.codecharge.components.ControlType.TEXT );
            Modifica__14.setHtmlEncode( true );
            Modifica__14.setHrefSourceValue( "AdmGuide" + Names.ACTION_SUFFIX );
            Modifica__14.setHrefType( "Page" );
            Modifica__14.setConvertRule("Relative");
            Modifica__14.setPreserveType(PreserveParameterType.NONE);
            Modifica__14.addParameter( new LinkParameter( "guida", "GUIDA", ParameterSource.DATAFIELD) );
            Modifica__14.addParameter( new LinkParameter( "seq", "SEQUENZA", ParameterSource.DATAFIELD) );
            AMV_GUIDE.add( Modifica__14 );

            com.codecharge.components.Label AFCNavigator__51 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__51.setType( com.codecharge.components.ControlType.TEXT );
            AMV_GUIDE.add(AFCNavigator__51);
            add(AMV_GUIDE);
        } // End definition of AMV_GUIDE grid model
//End AMV_GUIDE grid

//AMV_GUIDE1 record @19-0E852A0D
        
        /*
            Model of AMV_GUIDE1 record defining.
        */
        {
            com.codecharge.components.Record AMV_GUIDE1 = new com.codecharge.components.Record("AMV_GUIDE1");
            AMV_GUIDE1.setPageModel( this );
            AMV_GUIDE1.addExcludeParam( "ccsForm" );
            AMV_GUIDE1.setVisible( true );
            AMV_GUIDE1.setPreserveType(PreserveParameterType.NONE);
            AMV_GUIDE1.setReturnPage("AdmGuide" + Names.ACTION_SUFFIX);
            AMV_GUIDE1.addRecordListener(new AMV_GUIDE1RecordHandler());

            com.codecharge.components.TextBox TITOLO__20 = new com.codecharge.components.TextBox("TITOLO", "TITOLO", this );
            TITOLO__20.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__20.setHtmlEncode( true );
            TITOLO__20.setCaption( "TITOLO" );
            TITOLO__20.addValidateHandler( new RequiredHandler( "Il valore nel campo TITOLO è richiesto." ) );
            AMV_GUIDE1.add( TITOLO__20 );

            com.codecharge.components.Hidden GUIDA__33 = new com.codecharge.components.Hidden("GUIDA", "GUIDA", this );
            GUIDA__33.setType( com.codecharge.components.ControlType.TEXT );
            GUIDA__33.setHtmlEncode( true );
            AMV_GUIDE1.add( GUIDA__33 );

            com.codecharge.components.TextBox SEQUENZA__21 = new com.codecharge.components.TextBox("SEQUENZA", "SEQUENZA", this );
            SEQUENZA__21.setType( com.codecharge.components.ControlType.TEXT );
            SEQUENZA__21.setHtmlEncode( true );
            SEQUENZA__21.setCaption( "SEQUENZA" );
            SEQUENZA__21.addValidateHandler( new RequiredHandler( "Il valore nel campo SEQUENZA è richiesto." ) );
            AMV_GUIDE1.add( SEQUENZA__21 );

            com.codecharge.components.ListBox VOCE_MENU__22 = new com.codecharge.components.ListBox("VOCE_MENU", "VOCE_MENU", this );
            VOCE_MENU__22.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_MENU__22.setHtmlEncode( true );
            VOCE_MENU__22.setCaption( "VOCE_MENU" );
            VOCE_MENU__22.addValidateHandler( new RequiredHandler( "Il valore nel campo VOCE_MENU è richiesto." ) );
            AMV_GUIDE1.add( VOCE_MENU__22 );

            com.codecharge.components.TextBox ALIAS__49 = new com.codecharge.components.TextBox("ALIAS", "ALIAS", this );
            ALIAS__49.setType( com.codecharge.components.ControlType.TEXT );
            ALIAS__49.setHtmlEncode( true );
            AMV_GUIDE1.add( ALIAS__49 );

            com.codecharge.components.ListBox VOCE_RIF__47 = new com.codecharge.components.ListBox("VOCE_RIF", "VOCE_RIF", this );
            VOCE_RIF__47.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_RIF__47.setHtmlEncode( true );
            VOCE_RIF__47.setCaption( "VOCE_RIF" );
            AMV_GUIDE1.add( VOCE_RIF__47 );

            com.codecharge.components.Button Insert__24 = new com.codecharge.components.Button("Insert", this);
            Insert__24.addExcludeParam( "ccsForm" );
            Insert__24.addExcludeParam( "Insert" );
            Insert__24.setOperation( "Insert" );
            AMV_GUIDE1.add( Insert__24 );

            com.codecharge.components.Button Update__25 = new com.codecharge.components.Button("Update", this);
            Update__25.addExcludeParam( "ccsForm" );
            Update__25.addExcludeParam( "Update" );
            Update__25.setOperation( "Update" );
            AMV_GUIDE1.add( Update__25 );

            com.codecharge.components.Button Delete__26 = new com.codecharge.components.Button("Delete", this);
            Delete__26.addExcludeParam( "ccsForm" );
            Delete__26.addExcludeParam( "Delete" );
            Delete__26.setOperation( "Delete" );
            AMV_GUIDE1.add( Delete__26 );

            com.codecharge.components.Button Cancel__27 = new com.codecharge.components.Button("Cancel", this);
            Cancel__27.addExcludeParam( "ccsForm" );
            Cancel__27.addExcludeParam( "Cancel" );
            Cancel__27.setOperation( "Cancel" );
            AMV_GUIDE1.add( Cancel__27 );
            add(AMV_GUIDE1);
        } // End definition of AMV_GUIDE1 record model.
//End AMV_GUIDE1 record

//AdmGuideModel class tail @1-F5FC18C5
    }
}
//End AdmGuideModel class tail

