//AmvLoginModel imports @1-FBCD72F2
package common.AmvLogin;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLoginModel imports

//AmvLoginModel class head @1-0D67357A
public class AmvLoginModel extends com.codecharge.components.Page {
    public AmvLoginModel() {
        this( new CCSLocale(), null );
    }

    public AmvLoginModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLoginModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLoginModel class head

//page settings @1-D8530B6A
        super("AmvLogin", locale );
        setResponse(response);
        setIncluded(true);
        addPageListener(new AmvLoginPageHandler());
        {
        } // end page
//End page settings

//LOGIN record @2-52FFA870
        
        /*
            Model of LOGIN record defining.
        */
        {
            com.codecharge.components.Record LOGIN = new com.codecharge.components.Record("LOGIN");
            LOGIN.setPageModel( this );
            LOGIN.addExcludeParam( "ccsForm" );
            LOGIN.setVisible( true );
            LOGIN.setAllowInsert(false);
            LOGIN.setAllowUpdate(false);
            LOGIN.setAllowDelete(false);
            LOGIN.setPreserveType(PreserveParameterType.GET);
            LOGIN.setReturnPage("AmvLogin" + Names.ACTION_SUFFIX);

            com.codecharge.components.Label ERRORE__3 = new com.codecharge.components.Label("ERRORE", "ERRORE", this );
            ERRORE__3.setType( com.codecharge.components.ControlType.TEXT );
            LOGIN.add(ERRORE__3);

            com.codecharge.components.TextBox j_username__4 = new com.codecharge.components.TextBox("j_username", "", this );
            j_username__4.setType( com.codecharge.components.ControlType.TEXT );
            j_username__4.setHtmlEncode( true );
            LOGIN.add( j_username__4 );

            com.codecharge.components.TextBox j_password__5 = new com.codecharge.components.TextBox("j_password", "", this );
            j_password__5.setType( com.codecharge.components.ControlType.TEXT );
            j_password__5.setHtmlEncode( true );
            LOGIN.add( j_password__5 );

            com.codecharge.components.Button Login__11 = new com.codecharge.components.Button("Login", this);
            Login__11.addExcludeParam( "ccsForm" );
            Login__11.addExcludeParam( "Login" );
            Login__11.setOperation( "Search" );
            LOGIN.add( Login__11 );

            com.codecharge.components.Label LOSTMSG__12 = new com.codecharge.components.Label("LOSTMSG", "LOSTMSG", this );
            LOSTMSG__12.setType( com.codecharge.components.ControlType.TEXT );
            LOGIN.add(LOSTMSG__12);
            add(LOGIN);
        } // End definition of LOGIN record model.
//End LOGIN record

//AmvLoginModel class tail @1-F5FC18C5
    }
}
//End AmvLoginModel class tail

