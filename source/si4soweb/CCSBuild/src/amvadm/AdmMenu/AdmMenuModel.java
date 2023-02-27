//AdmMenuModel imports @1-C40EBD38
package amvadm.AdmMenu;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmMenuModel imports

//AdmMenuModel class head @1-2F0C9ECB
public class AdmMenuModel extends com.codecharge.components.Page {
    public AdmMenuModel() {
        this( new CCSLocale(), null );
    }

    public AdmMenuModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmMenuModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmMenuModel class head

//page settings @1-4D8A1214
        super("AdmMenu", locale );
        setResponse(response);
        addPageListener(new AdmMenuPageHandler());
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage AmvGuida__5 = new com.codecharge.components.IncludePage("AmvGuida", this );
            AmvGuida__5.setVisible( true );
            add( AmvGuida__5 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//Ruolo record @6-70944EBA
        
        /*
            Model of Ruolo record defining.
        */
        {
            com.codecharge.components.Record Ruolo = new com.codecharge.components.Record("Ruolo");
            Ruolo.setPageModel( this );
            Ruolo.addExcludeParam( "ccsForm" );
            Ruolo.addExcludeParam( "VC" );
            Ruolo.setVisible( true );
            Ruolo.setAllowInsert(false);
            Ruolo.setAllowUpdate(false);
            Ruolo.setAllowDelete(false);
            Ruolo.setPreserveType(PreserveParameterType.NONE);
            Ruolo.setReturnPage("AdmMenu" + Names.ACTION_SUFFIX);

            com.codecharge.components.ListBox SP__150 = new com.codecharge.components.ListBox("SP", "PROGETTO_SEL", this );
            SP__150.setType( com.codecharge.components.ControlType.TEXT );
            SP__150.setHtmlEncode( true );
            SP__150.setBoundColumn( "PROGETTO" );
            SP__150.setTextColumn( "DESCRIZIONE" );
            Ruolo.add( SP__150 );

            com.codecharge.components.ListBox SM__7 = new com.codecharge.components.ListBox("SM", "MODULO_SEL", this );
            SM__7.setType( com.codecharge.components.ControlType.TEXT );
            SM__7.setHtmlEncode( true );
            SM__7.setBoundColumn( "MODULO" );
            SM__7.setTextColumn( "DESCRIZIONE" );
            Ruolo.add( SM__7 );

            com.codecharge.components.ListBox SR__10 = new com.codecharge.components.ListBox("SR", "RUOLO_SEL", this );
            SR__10.setType( com.codecharge.components.ControlType.TEXT );
            SR__10.setHtmlEncode( true );
            SR__10.setBoundColumn( "RUOLO" );
            SR__10.setTextColumn( "DESCRIZIONE" );
            Ruolo.add( SR__10 );
            add(Ruolo);
        } // End definition of Ruolo record model.
//End Ruolo record

//Albero grid @15-6FEB8B4A
        
        /*
            // Begin definition of Albero grid model.
        */
        {
            com.codecharge.components.Grid Albero = new com.codecharge.components.Grid("Albero");
            Albero.setPageModel( this );
            Albero.setFetchSize(300);
            Albero.setVisible( true );

            com.codecharge.components.Label MENU__16 = new com.codecharge.components.Label("MENU", "TABELLA", this );
            MENU__16.setType( com.codecharge.components.ControlType.TEXT );
            Albero.add(MENU__16);
            add(Albero);
        } // End definition of Albero grid model
//End Albero grid

//AMV_VOCI record @35-8A85B7F5
        
        /*
            Model of AMV_VOCI record defining.
        */
        {
            com.codecharge.components.Record AMV_VOCI = new com.codecharge.components.Record("AMV_VOCI");
            AMV_VOCI.setPageModel( this );
            AMV_VOCI.addExcludeParam( "ccsForm" );
            AMV_VOCI.setVisible( true );
            AMV_VOCI.setPreserveType(PreserveParameterType.GET);
            AMV_VOCI.setReturnPage("AdmMenu" + Names.ACTION_SUFFIX);
            AMV_VOCI.addRecordListener(new AMV_VOCIRecordHandler());

            com.codecharge.components.TextBox VOCE_NEW__36 = new com.codecharge.components.TextBox("VOCE_NEW", "VOCE", this );
            VOCE_NEW__36.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_NEW__36.setHtmlEncode( true );
            VOCE_NEW__36.setCaption( "VOCE" );
            VOCE_NEW__36.addValidateHandler( new RequiredHandler( "Il valore nel campo VOCE è richiesto." ) );
            AMV_VOCI.add( VOCE_NEW__36 );

            com.codecharge.components.Hidden VOCE_OLD__37 = new com.codecharge.components.Hidden("VOCE_OLD", "VOCE", this );
            VOCE_OLD__37.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_OLD__37.setHtmlEncode( true );
            AMV_VOCI.add( VOCE_OLD__37 );

            com.codecharge.components.TextBox TITOLO__38 = new com.codecharge.components.TextBox("TITOLO", "TITOLO", this );
            TITOLO__38.setType( com.codecharge.components.ControlType.TEXT );
            TITOLO__38.setHtmlEncode( true );
            TITOLO__38.setCaption( "TITOLO" );
            TITOLO__38.addValidateHandler( new RequiredHandler( "Il valore nel campo TITOLO è richiesto." ) );
            AMV_VOCI.add( TITOLO__38 );

            com.codecharge.components.ListBox TIPO__39 = new com.codecharge.components.ListBox("TIPO", "TIPO_LIST", this );
            TIPO__39.setType( com.codecharge.components.ControlType.TEXT );
            TIPO__39.setHtmlEncode( true );
            TIPO__39.setCaption( "TIPO" );
            TIPO__39.addValidateHandler( new RequiredHandler( "Il valore nel campo TIPO è richiesto." ) );
            AMV_VOCI.add( TIPO__39 );

            com.codecharge.components.TextBox STRINGA__40 = new com.codecharge.components.TextBox("STRINGA", "STRINGA", this );
            STRINGA__40.setType( com.codecharge.components.ControlType.TEXT );
            STRINGA__40.setHtmlEncode( true );
            STRINGA__40.setCaption( "STRINGA" );
            AMV_VOCI.add( STRINGA__40 );

            com.codecharge.components.TextBox MODULO__146 = new com.codecharge.components.TextBox("MODULO", "MODULO", this );
            MODULO__146.setType( com.codecharge.components.ControlType.TEXT );
            MODULO__146.setHtmlEncode( true );
            AMV_VOCI.add( MODULO__146 );

            com.codecharge.components.TextArea NOTE__41 = new com.codecharge.components.TextArea("NOTE", "NOTE", this );
            NOTE__41.setType( com.codecharge.components.ControlType.TEXT );
            NOTE__41.setHtmlEncode( true );
            NOTE__41.setCaption( "NOTE" );
            AMV_VOCI.add( NOTE__41 );

            com.codecharge.components.ListBox VOCE_GUIDA__42 = new com.codecharge.components.ListBox("VOCE_GUIDA", "VOCE_GUIDA", this );
            VOCE_GUIDA__42.setType( com.codecharge.components.ControlType.TEXT );
            VOCE_GUIDA__42.setHtmlEncode( true );
            VOCE_GUIDA__42.setBoundColumn( "VOCE" );
            VOCE_GUIDA__42.setTextColumn( "TITOLO" );
            AMV_VOCI.add( VOCE_GUIDA__42 );

            com.codecharge.components.Hidden SM__45 = new com.codecharge.components.Hidden("SM", "MODULO_SEL", this );
            SM__45.setType( com.codecharge.components.ControlType.TEXT );
            SM__45.setHtmlEncode( true );
            AMV_VOCI.add( SM__45 );

            com.codecharge.components.ListBox PD__49 = new com.codecharge.components.ListBox("PD", "", this );
            PD__49.setType( com.codecharge.components.ControlType.TEXT );
            PD__49.setHtmlEncode( true );
            PD__49.setBoundColumn( "ABILITAZIONE" );
            PD__49.setTextColumn( "TITOLO" );
            AMV_VOCI.add( PD__49 );

            com.codecharge.components.Hidden PADRE_OLD__52 = new com.codecharge.components.Hidden("PADRE_OLD", "PADRE_OLD", this );
            PADRE_OLD__52.setType( com.codecharge.components.ControlType.TEXT );
            PADRE_OLD__52.setHtmlEncode( true );
            AMV_VOCI.add( PADRE_OLD__52 );

            com.codecharge.components.TextBox SQ__53 = new com.codecharge.components.TextBox("SQ", "", this );
            SQ__53.setType( com.codecharge.components.ControlType.TEXT );
            SQ__53.setHtmlEncode( true );
            AMV_VOCI.add( SQ__53 );

            com.codecharge.components.Hidden RUOLO__142 = new com.codecharge.components.Hidden("RUOLO", "RUOLO_SEL", this );
            RUOLO__142.setType( com.codecharge.components.ControlType.TEXT );
            RUOLO__142.setHtmlEncode( true );
            AMV_VOCI.add( RUOLO__142 );

            com.codecharge.components.Hidden MVDIRUPLOAD__165 = new com.codecharge.components.Hidden("MVDIRUPLOAD", "MVDIRUPLOAD", this );
            MVDIRUPLOAD__165.setType( com.codecharge.components.ControlType.TEXT );
            MVDIRUPLOAD__165.setHtmlEncode( true );
            AMV_VOCI.add( MVDIRUPLOAD__165 );

            com.codecharge.components.RadioButton AB__54 = new com.codecharge.components.RadioButton("AB", "STATO_ABIL", this );
            AB__54.setType( com.codecharge.components.ControlType.TEXT );
            AB__54.setHtmlEncode( true );
            AMV_VOCI.add( AB__54 );

            com.codecharge.components.Link Nuovo__55 = new com.codecharge.components.Link("Nuovo", "NUOVO", this );
            Nuovo__55.setType( com.codecharge.components.ControlType.TEXT );
            Nuovo__55.setHtmlEncode( true );
            Nuovo__55.setHrefSourceValue( "AdmMenu" + Names.ACTION_SUFFIX );
            Nuovo__55.setHrefType( "Page" );
            Nuovo__55.setConvertRule("Relative");
            Nuovo__55.setPreserveType(PreserveParameterType.GET);
            Nuovo__55.addExcludeParam( "VC" );
            Nuovo__55.addExcludeParam( "AB" );
            AMV_VOCI.add( Nuovo__55 );

            com.codecharge.components.Button Insert__56 = new com.codecharge.components.Button("Insert", this);
            Insert__56.addExcludeParam( "ccsForm" );
            Insert__56.addExcludeParam( "Insert" );
            Insert__56.setOperation( "Insert" );
            AMV_VOCI.add( Insert__56 );

            com.codecharge.components.Button Update__57 = new com.codecharge.components.Button("Update", this);
            Update__57.addExcludeParam( "ccsForm" );
            Update__57.addExcludeParam( "Update" );
            Update__57.setOperation( "Update" );
            AMV_VOCI.add( Update__57 );

            com.codecharge.components.Button Delete__58 = new com.codecharge.components.Button("Delete", this);
            Delete__58.addExcludeParam( "ccsForm" );
            Delete__58.addExcludeParam( "Delete" );
            Delete__58.setOperation( "Delete" );
            AMV_VOCI.add( Delete__58 );
            add(AMV_VOCI);
        } // End definition of AMV_VOCI record model.
//End AMV_VOCI record

//AdmMenuModel class tail @1-F5FC18C5
    }
}
//End AdmMenuModel class tail

