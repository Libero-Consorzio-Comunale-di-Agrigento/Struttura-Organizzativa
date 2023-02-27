//LoginModel imports @1-C528FAA7
package common.Login;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End LoginModel imports

//LoginModel class head @1-FCC99AF0
public class LoginModel extends com.codecharge.components.Page {
    public LoginModel() {
        this( new CCSLocale(), null );
    }

    public LoginModel(CCSLocale locale) {
        this( locale, null );
    }

    public LoginModel( CCSLocale locale, HttpServletResponse response ) {
//End LoginModel class head

//page settings @1-51C7E986
        super("Login", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage AmvLogin__6 = new com.codecharge.components.IncludePage("AmvLogin", this );
            AmvLogin__6.setVisible( true );
            add( AmvLogin__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//LoginModel class tail @1-F5FC18C5
    }
}
//End LoginModel class tail



