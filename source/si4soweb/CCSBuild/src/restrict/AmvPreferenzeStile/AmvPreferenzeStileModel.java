//AmvPreferenzeStileModel imports @1-79E770B8
package restrict.AmvPreferenzeStile;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvPreferenzeStileModel imports

//AmvPreferenzeStileModel class head @1-F7374626
public class AmvPreferenzeStileModel extends com.codecharge.components.Page {
    public AmvPreferenzeStileModel() {
        this( new CCSLocale(), null );
    }

    public AmvPreferenzeStileModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvPreferenzeStileModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvPreferenzeStileModel class head

//page settings @1-8E603595
        super("AmvPreferenzeStile", locale );
        setResponse(response);
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
            com.codecharge.components.IncludePage AmvStili__6 = new com.codecharge.components.IncludePage("AmvStili", this );
            AmvStili__6.setVisible( true );
            add( AmvStili__6 );
            com.codecharge.components.IncludePage Versione__31 = new com.codecharge.components.IncludePage("Versione", this );
            Versione__31.setVisible( true );
            add( Versione__31 );
            com.codecharge.components.IncludePage AmvVersione__32 = new com.codecharge.components.IncludePage("AmvVersione", this );
            AmvVersione__32.setVisible( true );
            add( AmvVersione__32 );
        } // end page
//End page settings

//STILE_ATTUALE grid @7-2C8DEF6D
        
        /*
            // Begin definition of STILE_ATTUALE grid model.
        */
        {
            com.codecharge.components.Grid STILE_ATTUALE = new com.codecharge.components.Grid("STILE_ATTUALE");
            STILE_ATTUALE.setPageModel( this );
            STILE_ATTUALE.setFetchSize(20);
            STILE_ATTUALE.setVisible( true );

            com.codecharge.components.TextBox STILE_SCELTO__12 = new com.codecharge.components.TextBox("STILE_SCELTO", "STILE_SCELTO", this );
            STILE_SCELTO__12.setType( com.codecharge.components.ControlType.TEXT );
            STILE_SCELTO__12.setHtmlEncode( true );
            STILE_ATTUALE.add( STILE_SCELTO__12 );

            com.codecharge.components.TextBox STILE__8 = new com.codecharge.components.TextBox("STILE", "STILE_ATTUALE", this );
            STILE__8.setType( com.codecharge.components.ControlType.TEXT );
            STILE__8.setHtmlEncode( true );
            STILE_ATTUALE.add( STILE__8 );

            com.codecharge.components.Link CONFERMA__59 = new com.codecharge.components.Link("CONFERMA", "", this );
            CONFERMA__59.setType( com.codecharge.components.ControlType.TEXT );
            CONFERMA__59.setHtmlEncode( true );
            CONFERMA__59.setHrefSourceValue( "AmvStileAggiorna" + Names.ACTION_SUFFIX );
            CONFERMA__59.setHrefType( "Page" );
            CONFERMA__59.setConvertRule("Relative");
            CONFERMA__59.setPreserveType(PreserveParameterType.NONE);
            CONFERMA__59.addParameter( new LinkParameter( "ccsForm", "CCSFORM", ParameterSource.DATAFIELD) );
            CONFERMA__59.addParameter( new LinkParameter( "STYLESHEET", "STILE_SCELTO", ParameterSource.DATAFIELD) );
            CONFERMA__59.addParameter( new LinkParameter( "Button_Update", "BUTTONUPDATE", ParameterSource.DATAFIELD) );
            CONFERMA__59.addParameter( new LinkParameter( "MVID", "MVID", ParameterSource.DATAFIELD) );
            STILE_ATTUALE.add( CONFERMA__59 );
            add(STILE_ATTUALE);
        } // End definition of STILE_ATTUALE grid model
//End STILE_ATTUALE grid

//NewRecord1 record @42-1BA6EC70
        
        /*
            Model of NewRecord1 record defining.
        */
        {
            com.codecharge.components.Record NewRecord1 = new com.codecharge.components.Record("NewRecord1");
            NewRecord1.setPageModel( this );
            NewRecord1.addExcludeParam( "ccsForm" );
            NewRecord1.setVisible( true );
            NewRecord1.setAllowInsert(false);
            NewRecord1.setAllowUpdate(false);
            NewRecord1.setAllowDelete(false);
            NewRecord1.setPreserveType(PreserveParameterType.GET);
            NewRecord1.setReturnPage("AmvPreferenzeStile" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox TextBox0__54 = new com.codecharge.components.TextBox("TextBox0", "TESTO0", this );
            TextBox0__54.setType( com.codecharge.components.ControlType.TEXT );
            TextBox0__54.setHtmlEncode( true );
            NewRecord1.add( TextBox0__54 );
            com.codecharge.components.DatePicker DatePicker1__65 = new com.codecharge.components.DatePicker("DatePicker1", this);
            DatePicker1__65.setControlName("TextBox0");
            DatePicker1__65.setStyleName("../Themes/AFC/Style.css");
            NewRecord1.add(DatePicker1__65);

            com.codecharge.components.TextBox TextBox1__43 = new com.codecharge.components.TextBox("TextBox1", "TESTO1", this );
            TextBox1__43.setType( com.codecharge.components.ControlType.TEXT );
            TextBox1__43.setHtmlEncode( true );
            NewRecord1.add( TextBox1__43 );

            com.codecharge.components.TextBox TextBox2__55 = new com.codecharge.components.TextBox("TextBox2", "TESTO2", this );
            TextBox2__55.setType( com.codecharge.components.ControlType.TEXT );
            TextBox2__55.setHtmlEncode( true );
            NewRecord1.add( TextBox2__55 );

            com.codecharge.components.TextBox TextBox3__56 = new com.codecharge.components.TextBox("TextBox3", "TESTO3", this );
            TextBox3__56.setType( com.codecharge.components.ControlType.TEXT );
            TextBox3__56.setHtmlEncode( true );
            NewRecord1.add( TextBox3__56 );

            com.codecharge.components.Link Modifica__64 = new com.codecharge.components.Link("Modifica", "", this );
            Modifica__64.setType( com.codecharge.components.ControlType.TEXT );
            Modifica__64.setHtmlEncode( true );
            Modifica__64.setHrefType( "Page" );
            Modifica__64.setConvertRule("Relative");
            Modifica__64.setPreserveType(PreserveParameterType.GET);
            NewRecord1.add( Modifica__64 );

            com.codecharge.components.TextArea TextArea1__57 = new com.codecharge.components.TextArea("TextArea1", "TESTO1", this );
            TextArea1__57.setType( com.codecharge.components.ControlType.TEXT );
            TextArea1__57.setHtmlEncode( true );
            NewRecord1.add( TextArea1__57 );

            com.codecharge.components.Link Link1__58 = new com.codecharge.components.Link("Link1", "", this );
            Link1__58.setType( com.codecharge.components.ControlType.TEXT );
            Link1__58.setHtmlEncode( true );
            Link1__58.setHrefType( "Page" );
            Link1__58.setConvertRule("Relative");
            Link1__58.setPreserveType(PreserveParameterType.GET);
            NewRecord1.add( Link1__58 );

            com.codecharge.components.Button Button_Update__46 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__46.addExcludeParam( "ccsForm" );
            Button_Update__46.addExcludeParam( "Button_Update" );
            NewRecord1.add( Button_Update__46 );

            com.codecharge.components.Button Button_Delete__47 = new com.codecharge.components.Button("Button_Delete", this);
            Button_Delete__47.addExcludeParam( "ccsForm" );
            Button_Delete__47.addExcludeParam( "Button_Delete" );
            NewRecord1.add( Button_Delete__47 );
            add(NewRecord1);
        } // End definition of NewRecord1 record model.
//End NewRecord1 record

//NewGrid1 grid @48-9940B2DD
        
        /*
            // Begin definition of NewGrid1 grid model.
        */
        {
            com.codecharge.components.Grid NewGrid1 = new com.codecharge.components.Grid("NewGrid1");
            NewGrid1.setPageModel( this );
            NewGrid1.setFetchSize(2);
            NewGrid1.setVisible( true );
            com.codecharge.components.Sorter Sorter1 = new com.codecharge.components.Sorter("Sorter1", NewGrid1, this);
            Sorter1.setColumn("");
            NewGrid1.add(Sorter1);

            com.codecharge.components.Link Link1__53 = new com.codecharge.components.Link("Link1", "TESTO1", this );
            Link1__53.setType( com.codecharge.components.ControlType.TEXT );
            Link1__53.setHtmlEncode( true );
            Link1__53.setHrefType( "Page" );
            Link1__53.setConvertRule("Relative");
            Link1__53.setPreserveType(PreserveParameterType.GET);
            NewGrid1.add( Link1__53 );

            com.codecharge.components.Label Label2__50 = new com.codecharge.components.Label("Label2", "TESTO2", this );
            Label2__50.setType( com.codecharge.components.ControlType.TEXT );
            Label2__50.setHtmlEncode( true );
            NewGrid1.add(Label2__50);
            com.codecharge.components.Navigator Navigator__51 = new com.codecharge.components.Navigator("Navigator", NewGrid1, this);
            Navigator__51.setNavigatorType(com.codecharge.components.Navigator.SIMPLE);
            NewGrid1.add(Navigator__51);
            add(NewGrid1);
        } // End definition of NewGrid1 grid model
//End NewGrid1 grid

//copyright grid @25-7BF61310
        
        /*
            // Begin definition of copyright grid model.
        */
        {
            com.codecharge.components.Grid copyright = new com.codecharge.components.Grid("copyright");
            copyright.setPageModel( this );
            copyright.setFetchSize(20);
            copyright.setVisible( true );

            com.codecharge.components.Label MESSAGGIO__26 = new com.codecharge.components.Label("MESSAGGIO", "MESSAGGIO", this );
            MESSAGGIO__26.setType( com.codecharge.components.ControlType.TEXT );
            copyright.add(MESSAGGIO__26);

            com.codecharge.components.Label STILE__27 = new com.codecharge.components.Label("STILE", "STILE", this );
            STILE__27.setType( com.codecharge.components.ControlType.TEXT );
            copyright.add(STILE__27);
            add(copyright);
        } // End definition of copyright grid model
//End copyright grid

//AmvPreferenzeStileModel class tail @1-F5FC18C5
    }
}
//End AmvPreferenzeStileModel class tail


