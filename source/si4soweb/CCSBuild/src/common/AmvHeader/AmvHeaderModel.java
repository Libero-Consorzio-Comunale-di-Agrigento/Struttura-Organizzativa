//AmvHeaderModel imports @1-78C3A691
package common.AmvHeader;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvHeaderModel imports

//AmvHeaderModel class head @1-EA610E27
public class AmvHeaderModel extends com.codecharge.components.Page {
    public AmvHeaderModel() {
        this( new CCSLocale(), null );
    }

    public AmvHeaderModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvHeaderModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvHeaderModel class head

//page settings @1-A4E034B4
        super("AmvHeader", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvControl__62 = new com.codecharge.components.IncludePage("AmvControl", this );
            AmvControl__62.setVisible( true );
            add( AmvControl__62 );
            com.codecharge.components.IncludePage AmvAccessControl__69 = new com.codecharge.components.IncludePage("AmvAccessControl", this );
            AmvAccessControl__69.setVisible( true );
            add( AmvAccessControl__69 );
        } // end page
//End page settings

//LOGO grid @41-455E1F14
        
        /*
            // Begin definition of LOGO grid model.
        */
        {
            com.codecharge.components.Grid LOGO = new com.codecharge.components.Grid("LOGO");
            LOGO.setPageModel( this );
            LOGO.setFetchSize(20);
            LOGO.setVisible( true );

            com.codecharge.components.Label LOGO__42 = new com.codecharge.components.Label("LOGO", "LOGO", this );
            LOGO__42.setType( com.codecharge.components.ControlType.TEXT );
            LOGO.add(LOGO__42);
            add(LOGO);
        } // End definition of LOGO grid model
//End LOGO grid

//welcome grid @19-030603E5
        
        /*
            // Begin definition of welcome grid model.
        */
        {
            com.codecharge.components.Grid welcome = new com.codecharge.components.Grid("welcome");
            welcome.setPageModel( this );
            welcome.setFetchSize(20);
            welcome.setVisible( true );

            com.codecharge.components.Label INTESTAZIONE__61 = new com.codecharge.components.Label("INTESTAZIONE", "INTESTAZIONE", this );
            INTESTAZIONE__61.setType( com.codecharge.components.ControlType.TEXT );
            welcome.add(INTESTAZIONE__61);

            com.codecharge.components.Label MESSAGGIO__20 = new com.codecharge.components.Label("MESSAGGIO", "MESSAGGIO", this );
            MESSAGGIO__20.setType( com.codecharge.components.ControlType.TEXT );
            welcome.add(MESSAGGIO__20);

            com.codecharge.components.Label OGGI__21 = new com.codecharge.components.Label("OGGI", "OGGI", this );
            OGGI__21.setType( com.codecharge.components.ControlType.TEXT );
            welcome.add(OGGI__21);

            com.codecharge.components.Label NOTE__22 = new com.codecharge.components.Label("NOTE", "NOTE", this );
            NOTE__22.setType( com.codecharge.components.ControlType.TEXT );
            welcome.add(NOTE__22);

            com.codecharge.components.Label NEW_MSG__27 = new com.codecharge.components.Label("NEW_MSG", "NUOVI_MSG", this );
            NEW_MSG__27.setType( com.codecharge.components.ControlType.TEXT );
            welcome.add(NEW_MSG__27);
            add(welcome);
        } // End definition of welcome grid model
//End welcome grid

//LOGO_PORTALE grid @43-E61D64ED
        
        /*
            // Begin definition of LOGO_PORTALE grid model.
        */
        {
            com.codecharge.components.Grid LOGO_PORTALE = new com.codecharge.components.Grid("LOGO_PORTALE");
            LOGO_PORTALE.setPageModel( this );
            LOGO_PORTALE.setFetchSize(20);
            LOGO_PORTALE.setVisible( true );

            com.codecharge.components.Label LOGO_PORTALE__44 = new com.codecharge.components.Label("LOGO_PORTALE", "LOGO_PORTALE", this );
            LOGO_PORTALE__44.setType( com.codecharge.components.ControlType.TEXT );
            LOGO_PORTALE.add(LOGO_PORTALE__44);
            add(LOGO_PORTALE);
        } // End definition of LOGO_PORTALE grid model
//End LOGO_PORTALE grid

//AD4_MODULI grid @28-93C3E709
        
        /*
            // Begin definition of AD4_MODULI grid model.
        */
        {
            com.codecharge.components.Grid AD4_MODULI = new com.codecharge.components.Grid("AD4_MODULI");
            AD4_MODULI.setPageModel( this );
            AD4_MODULI.setFetchSize(10);
            AD4_MODULI.setVisible( true );

            com.codecharge.components.Label RETURN_PAGE__48 = new com.codecharge.components.Label("RETURN_PAGE", "RETURN_PAGE", this );
            RETURN_PAGE__48.setType( com.codecharge.components.ControlType.TEXT );
            AD4_MODULI.add(RETURN_PAGE__48);

            com.codecharge.components.Label NAVIGATORE__68 = new com.codecharge.components.Label("NAVIGATORE", "NAVIGATORE", this );
            NAVIGATORE__68.setType( com.codecharge.components.ControlType.TEXT );
            AD4_MODULI.add(NAVIGATORE__68);

            com.codecharge.components.Label MENUBAR__67 = new com.codecharge.components.Label("MENUBAR", "MENUBAR", this );
            MENUBAR__67.setType( com.codecharge.components.ControlType.TEXT );
            AD4_MODULI.add(MENUBAR__67);

            com.codecharge.components.Label SECTIONBAR__70 = new com.codecharge.components.Label("SECTIONBAR", "SECTIONBAR", this );
            SECTIONBAR__70.setType( com.codecharge.components.ControlType.TEXT );
            AD4_MODULI.add(SECTIONBAR__70);

            com.codecharge.components.Label HELP__50 = new com.codecharge.components.Label("HELP", "HELP", this );
            HELP__50.setType( com.codecharge.components.ControlType.TEXT );
            HELP__50.addControlListener( new AD4_MODULIHELPHandler());
            AD4_MODULI.add(HELP__50);
            add(AD4_MODULI);
        } // End definition of AD4_MODULI grid model
//End AD4_MODULI grid

//AmvHeaderModel class tail @1-F5FC18C5
    }
}
//End AmvHeaderModel class tail

