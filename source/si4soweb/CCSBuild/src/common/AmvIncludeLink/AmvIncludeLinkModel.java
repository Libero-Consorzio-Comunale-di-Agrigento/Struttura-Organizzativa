//AmvIncludeLinkModel imports @1-96899E2B
package common.AmvIncludeLink;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvIncludeLinkModel imports

//AmvIncludeLinkModel class head @1-067D918B
public class AmvIncludeLinkModel extends com.codecharge.components.Page {
    public AmvIncludeLinkModel() {
        this( new CCSLocale(), null );
    }

    public AmvIncludeLinkModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvIncludeLinkModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvIncludeLinkModel class head

//page settings @1-DB67F18F
        super("AmvIncludeLink", locale );
        setResponse(response);
        setIncluded(true);
        {
        } // end page
//End page settings

//Pagina grid @3-A8B1B162
        
        /*
            // Begin definition of Pagina grid model.
        */
        {
            com.codecharge.components.Grid Pagina = new com.codecharge.components.Grid("Pagina");
            Pagina.setPageModel( this );
            Pagina.setFetchSize(20);
            Pagina.setVisible( true );
            Pagina.addGridListener( new PaginaGridHandler() );

            com.codecharge.components.Label PAGE_LINK__6 = new com.codecharge.components.Label("PAGE_LINK", this);
            PAGE_LINK__6.setType( com.codecharge.components.ControlType.TEXT );
            Pagina.add(PAGE_LINK__6);
            add(Pagina);
        } // End definition of Pagina grid model
//End Pagina grid

//AmvIncludeLinkModel class tail @1-F5FC18C5
    }
}
//End AmvIncludeLinkModel class tail


