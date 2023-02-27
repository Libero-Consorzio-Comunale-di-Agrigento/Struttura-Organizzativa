//AmvServiziAbilitatiElenco_iModel imports @1-992364AD
package common.AmvServiziAbilitatiElenco_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziAbilitatiElenco_iModel imports

//AmvServiziAbilitatiElenco_iModel class head @1-50AFC07E
public class AmvServiziAbilitatiElenco_iModel extends com.codecharge.components.Page {
    public AmvServiziAbilitatiElenco_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziAbilitatiElenco_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziAbilitatiElenco_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziAbilitatiElenco_iModel class head

//page settings @1-1EE5DB5D
        super("AmvServiziAbilitatiElenco_i", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//SERVIZI_ABILITATI grid @10-CA3C9414
        
        /*
            // Begin definition of SERVIZI_ABILITATI grid model.
        */
        {
            com.codecharge.components.Grid SERVIZI_ABILITATI = new com.codecharge.components.Grid("SERVIZI_ABILITATI");
            SERVIZI_ABILITATI.setPageModel( this );
            SERVIZI_ABILITATI.setFetchSize(10);
            SERVIZI_ABILITATI.setVisible( true );
            SERVIZI_ABILITATI.addGridListener( new SERVIZI_ABILITATIGridHandler() );

            com.codecharge.components.Label Label1__40 = new com.codecharge.components.Label("Label1", "", this );
            Label1__40.setType( com.codecharge.components.ControlType.TEXT );
            Label1__40.setHtmlEncode( true );
            Label1__40.addControlListener( new SERVIZI_ABILITATILabel1Handler());
            SERVIZI_ABILITATI.add(Label1__40);

            com.codecharge.components.Label DATA__12 = new com.codecharge.components.Label("DATA", "DATA", this );
            DATA__12.setType( com.codecharge.components.ControlType.TEXT );
            DATA__12.setHtmlEncode( true );
            SERVIZI_ABILITATI.add(DATA__12);

            com.codecharge.components.Label SERVIZIO__11 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__11.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__11.setHtmlEncode( true );
            SERVIZI_ABILITATI.add(SERVIZIO__11);

            com.codecharge.components.Label NOTIFICA__13 = new com.codecharge.components.Label("NOTIFICA", "NOTIFICA", this );
            NOTIFICA__13.setType( com.codecharge.components.ControlType.TEXT );
            NOTIFICA__13.setHtmlEncode( true );
            SERVIZI_ABILITATI.add(NOTIFICA__13);

            com.codecharge.components.Label AZIENDA__14 = new com.codecharge.components.Label("AZIENDA", "AZIENDA", this );
            AZIENDA__14.setType( com.codecharge.components.ControlType.TEXT );
            AZIENDA__14.setHtmlEncode( true );
            SERVIZI_ABILITATI.add(AZIENDA__14);

            com.codecharge.components.Label AFCNavigator__38 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__38.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZI_ABILITATI.add(AFCNavigator__38);
            add(SERVIZI_ABILITATI);
        } // End definition of SERVIZI_ABILITATI grid model
//End SERVIZI_ABILITATI grid

//AmvServiziAbilitatiElenco_iModel class tail @1-F5FC18C5
    }
}
//End AmvServiziAbilitatiElenco_iModel class tail



