//AmvUltimiAccessiModel imports @1-27DC50FB
package restrict.AmvUltimiAccessi;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvUltimiAccessiModel imports

//AmvUltimiAccessiModel class head @1-BDB12BCF
public class AmvUltimiAccessiModel extends com.codecharge.components.Page {
    public AmvUltimiAccessiModel() {
        this( new CCSLocale(), null );
    }

    public AmvUltimiAccessiModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvUltimiAccessiModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvUltimiAccessiModel class head

//page settings @1-1C9EF93C
        super("AmvUltimiAccessi", locale );
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

//AccessiElenco grid @6-6E9FBA1A
        
        /*
            // Begin definition of AccessiElenco grid model.
        */
        {
            com.codecharge.components.Grid AccessiElenco = new com.codecharge.components.Grid("AccessiElenco");
            AccessiElenco.setPageModel( this );
            AccessiElenco.setFetchSize(10);
            AccessiElenco.setVisible( true );
            AccessiElenco.addGridListener( new AccessiElencoGridHandler() );

            com.codecharge.components.Link DES_ACCESSO__7 = new com.codecharge.components.Link("DES_ACCESSO", "DES_ACCESSO", this );
            DES_ACCESSO__7.setType( com.codecharge.components.ControlType.TEXT );
            DES_ACCESSO__7.setHtmlEncode( true );
            DES_ACCESSO__7.setHrefType( "Page" );
            DES_ACCESSO__7.setConvertRule("Relative");
            DES_ACCESSO__7.setPreserveType(PreserveParameterType.NONE);
            DES_ACCESSO__7.addParameter( new LinkParameter( "DES_ACCESSO", "DES_ACCESSO", ParameterSource.DATAFIELD) );
            DES_ACCESSO__7.addParameter( new LinkParameter( "DES_SERVIZIO", "DES_SERVIZIO", ParameterSource.DATAFIELD) );
            AccessiElenco.add( DES_ACCESSO__7 );

            com.codecharge.components.Label DES_SERVIZIO__8 = new com.codecharge.components.Label("DES_SERVIZIO", "DES_SERVIZIO", this );
            DES_SERVIZIO__8.setType( com.codecharge.components.ControlType.TEXT );
            AccessiElenco.add(DES_SERVIZIO__8);

            com.codecharge.components.Label AFCNavigator__34 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__34.setType( com.codecharge.components.ControlType.TEXT );
            AccessiElenco.add(AFCNavigator__34);
            add(AccessiElenco);
        } // End definition of AccessiElenco grid model
//End AccessiElenco grid

//AD4_SERVIZIO_SEL grid @23-33ADDA40
        
        /*
            // Begin definition of AD4_SERVIZIO_SEL grid model.
        */
        {
            com.codecharge.components.Grid AD4_SERVIZIO_SEL = new com.codecharge.components.Grid("AD4_SERVIZIO_SEL");
            AD4_SERVIZIO_SEL.setPageModel( this );
            AD4_SERVIZIO_SEL.setFetchSize(20);
            AD4_SERVIZIO_SEL.setVisible( true );
            AD4_SERVIZIO_SEL.addGridListener( new AD4_SERVIZIO_SELGridHandler() );

            com.codecharge.components.Label DES_ACCESSO__28 = new com.codecharge.components.Label("DES_ACCESSO", "DES_ACCESSO", this );
            DES_ACCESSO__28.setType( com.codecharge.components.ControlType.TEXT );
            DES_ACCESSO__28.setHtmlEncode( true );
            AD4_SERVIZIO_SEL.add(DES_ACCESSO__28);

            com.codecharge.components.Label DES_SERVIZIO__24 = new com.codecharge.components.Label("DES_SERVIZIO", "DES_SERVIZIO", this );
            DES_SERVIZIO__24.setType( com.codecharge.components.ControlType.TEXT );
            DES_SERVIZIO__24.setHtmlEncode( true );
            AD4_SERVIZIO_SEL.add(DES_SERVIZIO__24);
            add(AD4_SERVIZIO_SEL);
        } // End definition of AD4_SERVIZIO_SEL grid model
//End AD4_SERVIZIO_SEL grid

//AccessiDettaglio grid @14-9DA50FCA
        
        /*
            // Begin definition of AccessiDettaglio grid model.
        */
        {
            com.codecharge.components.Grid AccessiDettaglio = new com.codecharge.components.Grid("AccessiDettaglio");
            AccessiDettaglio.setPageModel( this );
            AccessiDettaglio.setFetchSize(20);
            AccessiDettaglio.setVisible( true );
            AccessiDettaglio.addGridListener( new AccessiDettaglioGridHandler() );

            com.codecharge.components.Label DES_ACCESSO__15 = new com.codecharge.components.Label("DES_ACCESSO", "DES_ACCESSO", this );
            DES_ACCESSO__15.setType( com.codecharge.components.ControlType.TEXT );
            DES_ACCESSO__15.setHtmlEncode( true );
            AccessiDettaglio.add(DES_ACCESSO__15);

            com.codecharge.components.Label DES_ORA__33 = new com.codecharge.components.Label("DES_ORA", "DES_ORA", this );
            DES_ORA__33.setType( com.codecharge.components.ControlType.TEXT );
            DES_ORA__33.setHtmlEncode( true );
            AccessiDettaglio.add(DES_ORA__33);

            com.codecharge.components.Label DSP_SESSIONE__17 = new com.codecharge.components.Label("DSP_SESSIONE", "DSP_SESSIONE", this );
            DSP_SESSIONE__17.setType( com.codecharge.components.ControlType.TEXT );
            AccessiDettaglio.add(DSP_SESSIONE__17);

            com.codecharge.components.Label AFCNavigator__35 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__35.setType( com.codecharge.components.ControlType.TEXT );
            AccessiDettaglio.add(AFCNavigator__35);
            add(AccessiDettaglio);
        } // End definition of AccessiDettaglio grid model
//End AccessiDettaglio grid

//AmvUltimiAccessiModel class tail @1-F5FC18C5
    }
}
//End AmvUltimiAccessiModel class tail

