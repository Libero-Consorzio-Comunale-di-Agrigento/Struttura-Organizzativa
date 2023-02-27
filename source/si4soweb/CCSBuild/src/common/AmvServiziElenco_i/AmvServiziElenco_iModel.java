//AmvServiziElenco_iModel imports @1-230E27FC
package common.AmvServiziElenco_i;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvServiziElenco_iModel imports

//AmvServiziElenco_iModel class head @1-3F59B8CD
public class AmvServiziElenco_iModel extends com.codecharge.components.Page {
    public AmvServiziElenco_iModel() {
        this( new CCSLocale(), null );
    }

    public AmvServiziElenco_iModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvServiziElenco_iModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvServiziElenco_iModel class head

//page settings @1-5164168E
        super("AmvServiziElenco_i", locale );
        setResponse(response);
        setIncluded(true);
        {
            com.codecharge.components.IncludePage AmvServiziRichiestiElenco_i__2 = new com.codecharge.components.IncludePage("AmvServiziRichiestiElenco_i", this );
            AmvServiziRichiestiElenco_i__2.setVisible( true );
            add( AmvServiziRichiestiElenco_i__2 );
            com.codecharge.components.IncludePage AmvServiziAbilitatiElenco_i__3 = new com.codecharge.components.IncludePage("AmvServiziAbilitatiElenco_i", this );
            AmvServiziAbilitatiElenco_i__3.setVisible( true );
            add( AmvServiziAbilitatiElenco_i__3 );
            com.codecharge.components.IncludePage AmvServiziDisponibiliElenco_i__4 = new com.codecharge.components.IncludePage("AmvServiziDisponibiliElenco_i", this );
            AmvServiziDisponibiliElenco_i__4.setVisible( true );
            add( AmvServiziDisponibiliElenco_i__4 );
        } // end page
//End page settings

//AmvServiziElenco_iModel class tail @1-F5FC18C5
    }
}
//End AmvServiziElenco_iModel class tail


