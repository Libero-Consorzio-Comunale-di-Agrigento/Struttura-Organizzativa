//AmvServiziDisponibiliElenco_iModel imports @1-A6816E61
package common.AmvServiziDisponibiliElenco_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziDisponibiliElenco_iModel imports

//AmvServiziDisponibiliElenco_iModel class head @1-44AA1613
public class AmvServiziDisponibiliElenco_iModel extends com.codecharge.components.Page {
    public AmvServiziDisponibiliElenco_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziDisponibiliElenco_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziDisponibiliElenco_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziDisponibiliElenco_iModel class head

//page settings @1-A6D2A0EE
        super("AmvServiziDisponibiliElenco_i", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//SERVIZI_DISPONIBILI grid @16-D11FEA4E
        
        /*
            // Begin definition of SERVIZI_DISPONIBILI grid model.
        */
        {
            com.codecharge.components.Grid SERVIZI_DISPONIBILI = new com.codecharge.components.Grid("SERVIZI_DISPONIBILI");
            SERVIZI_DISPONIBILI.setPageModel( this );
            SERVIZI_DISPONIBILI.setFetchSize(20);
            SERVIZI_DISPONIBILI.setVisible( true );
            SERVIZI_DISPONIBILI.addGridListener( new SERVIZI_DISPONIBILIGridHandler() );

            com.codecharge.components.Label SERVIZIO__17 = new com.codecharge.components.Label("SERVIZIO", "SERVIZIO", this );
            SERVIZIO__17.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZIO__17.setHtmlEncode( true );
            SERVIZI_DISPONIBILI.add(SERVIZIO__17);

            com.codecharge.components.Link RICHIESTA__18 = new com.codecharge.components.Link("RICHIESTA", "RICHIESTA", this );
            RICHIESTA__18.setType( com.codecharge.components.ControlType.TEXT );
            RICHIESTA__18.setHrefSourceValue( "/common/AmvServiziRichiesta" + Names.ACTION_SUFFIX );
            RICHIESTA__18.setHrefType( "Page" );
            RICHIESTA__18.setConvertRule("Relative");
            RICHIESTA__18.setPreserveType(PreserveParameterType.NONE);
            RICHIESTA__18.addParameter( new LinkParameter( "ISTANZA", "ISTANZA", ParameterSource.DATAFIELD) );
            RICHIESTA__18.addParameter( new LinkParameter( "MODULO", "MODULO", ParameterSource.DATAFIELD) );
            RICHIESTA__18.addParameter( new LinkParameter( "RR", "", ParameterSource.EXPRESSION) );
            SERVIZI_DISPONIBILI.add( RICHIESTA__18 );

            com.codecharge.components.Label AFCNavigator__39 = new com.codecharge.components.Label("AFCNavigator", this);
            AFCNavigator__39.setType( com.codecharge.components.ControlType.TEXT );
            SERVIZI_DISPONIBILI.add(AFCNavigator__39);
            add(SERVIZI_DISPONIBILI);
        } // End definition of SERVIZI_DISPONIBILI grid model
//End SERVIZI_DISPONIBILI grid

//AmvServiziDisponibiliElenco_iModel class tail @1-F5FC18C5
    }
}
//End AmvServiziDisponibiliElenco_iModel class tail



