//AmvGuidaBarModel imports @1-2A66FE0E
package common.AmvGuidaBar;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvGuidaBarModel imports

//AmvGuidaBarModel class head @1-FE626192
public class AmvGuidaBarModel extends com.codecharge.components.Page {
    public AmvGuidaBarModel() {
        this( new CCSLocale(), null );
    }

    public AmvGuidaBarModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvGuidaBarModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvGuidaBarModel class head

//page settings @1-14A2666E
        super("AmvGuidaBar", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Guida grid @2-61732FB1
        
        /*
            // Begin definition of Guida grid model.
        */
        {
            com.codecharge.components.Grid Guida = new com.codecharge.components.Grid("Guida");
            Guida.setPageModel( this );
            Guida.setFetchSize(20);
            Guida.setVisible( true );

            com.codecharge.components.Label SEPARATORE__11 = new com.codecharge.components.Label("SEPARATORE", "SEPARATORE", this );
            SEPARATORE__11.setType( com.codecharge.components.ControlType.TEXT );
            SEPARATORE__11.setHtmlEncode( true );
            Guida.add(SEPARATORE__11);

            com.codecharge.components.Label GUIDA__3 = new com.codecharge.components.Label("GUIDA", "TITOLO", this );
            GUIDA__3.setType( com.codecharge.components.ControlType.TEXT );
            Guida.add(GUIDA__3);
            add(Guida);
        } // End definition of Guida grid model
//End Guida grid

//GuidaPropria grid @13-F05816B5
        
        /*
            // Begin definition of GuidaPropria grid model.
        */
        {
            com.codecharge.components.Grid GuidaPropria = new com.codecharge.components.Grid("GuidaPropria");
            GuidaPropria.setPageModel( this );
            GuidaPropria.setFetchSize(20);
            GuidaPropria.setVisible( true );

            com.codecharge.components.Label SEPARATORE__14 = new com.codecharge.components.Label("SEPARATORE", "SEPARATORE", this );
            SEPARATORE__14.setType( com.codecharge.components.ControlType.TEXT );
            SEPARATORE__14.setHtmlEncode( true );
            GuidaPropria.add(SEPARATORE__14);

            com.codecharge.components.Label GUIDA__15 = new com.codecharge.components.Label("GUIDA", "TITOLO", this );
            GUIDA__15.setType( com.codecharge.components.ControlType.TEXT );
            GuidaPropria.add(GUIDA__15);
            add(GuidaPropria);
        } // End definition of GuidaPropria grid model
//End GuidaPropria grid

//AmvGuidaBarModel class tail @1-F5FC18C5
    }
}
//End AmvGuidaBarModel class tail


