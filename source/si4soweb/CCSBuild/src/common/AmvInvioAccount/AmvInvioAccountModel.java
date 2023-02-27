//AmvInvioAccountModel imports @1-CFAE51CB
package common.AmvInvioAccount;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvInvioAccountModel imports

//AmvInvioAccountModel class head @1-C30C5283
public class AmvInvioAccountModel extends com.codecharge.components.Page {
    public AmvInvioAccountModel() {
        this( new CCSLocale(), null );
    }

    public AmvInvioAccountModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvInvioAccountModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvInvioAccountModel class head

//page settings @1-428F6E72
        super("AmvInvioAccount", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AmvInvioAccountModel class tail @1-F5FC18C5
    }
}
//End AmvInvioAccountModel class tail
