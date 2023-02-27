//AmvGuidaModel imports @1-164BAA54
package common.AmvGuida;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvGuidaModel imports

//AmvGuidaModel class head @1-9DF17FCF
public class AmvGuidaModel extends com.codecharge.components.Page {
    public AmvGuidaModel() {
        this( new CCSLocale(), null );
    }

    public AmvGuidaModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvGuidaModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvGuidaModel class head

//page settings @1-DF171195
        super("AmvGuida", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Guida grid @2-C6AC3657
        
        /*
            // Begin definition of Guida grid model.
        */
        {
            com.codecharge.components.Grid Guida = new com.codecharge.components.Grid("Guida");
            Guida.setPageModel( this );
            Guida.setFetchSize(20);
            Guida.setVisible( true );

            com.codecharge.components.Label APERTURA__11 = new com.codecharge.components.Label("APERTURA", "APERTURA", this );
            APERTURA__11.setType( com.codecharge.components.ControlType.TEXT );
            Guida.add(APERTURA__11);

            com.codecharge.components.Label GUIDA__3 = new com.codecharge.components.Label("GUIDA", "TITOLO", this );
            GUIDA__3.setType( com.codecharge.components.ControlType.TEXT );
            Guida.add(GUIDA__3);

            com.codecharge.components.Label CHIUSURA__27 = new com.codecharge.components.Label("CHIUSURA", "CHIUSURA", this );
            CHIUSURA__27.setType( com.codecharge.components.ControlType.TEXT );
            Guida.add(CHIUSURA__27);
            add(Guida);
        } // End definition of Guida grid model
//End Guida grid

//GuidaPropria grid @13-B9D20EBC
        
        /*
            // Begin definition of GuidaPropria grid model.
        */
        {
            com.codecharge.components.Grid GuidaPropria = new com.codecharge.components.Grid("GuidaPropria");
            GuidaPropria.setPageModel( this );
            GuidaPropria.setFetchSize(20);
            GuidaPropria.setVisible( true );

            com.codecharge.components.Label APERTURA__14 = new com.codecharge.components.Label("APERTURA", "APERTURA", this );
            APERTURA__14.setType( com.codecharge.components.ControlType.TEXT );
            GuidaPropria.add(APERTURA__14);

            com.codecharge.components.Label GUIDA__15 = new com.codecharge.components.Label("GUIDA", "TITOLO", this );
            GUIDA__15.setType( com.codecharge.components.ControlType.TEXT );
            GuidaPropria.add(GUIDA__15);

            com.codecharge.components.Label CHIUSURA__29 = new com.codecharge.components.Label("CHIUSURA", "CHIUSURA", this );
            CHIUSURA__29.setType( com.codecharge.components.ControlType.TEXT );
            GuidaPropria.add(CHIUSURA__29);
            add(GuidaPropria);
        } // End definition of GuidaPropria grid model
//End GuidaPropria grid

//AmvGuidaModel class tail @1-F5FC18C5
    }
}
//End AmvGuidaModel class tail

