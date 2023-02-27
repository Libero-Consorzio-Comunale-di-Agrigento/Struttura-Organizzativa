//MainModel imports @1-54C0480A
package common.Main;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End MainModel imports

//MainModel class head @1-6B61A723
public class MainModel extends com.codecharge.components.Page {
    public MainModel() {
        this( new CCSLocale(), null );
    }

    public MainModel(CCSLocale locale) {
        this( locale, null );
    }

    public MainModel( CCSLocale locale, HttpServletResponse response ) {
//End MainModel class head

//page settings @1-6BF8986F
        super("Main", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__4 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__4.setVisible( true );
            add( AmvStyle__4 );
            com.codecharge.components.IncludePage AmvHome__3 = new com.codecharge.components.IncludePage("AmvHome", this );
            AmvHome__3.setVisible( true );
            add( AmvHome__3 );
            com.codecharge.components.IncludePage AmvMain__2 = new com.codecharge.components.IncludePage("AmvMain", this );
            AmvMain__2.setVisible( true );
            add( AmvMain__2 );
        } // end page
//End page settings

//MainModel class tail @1-F5FC18C5
    }
}
//End MainModel class tail

