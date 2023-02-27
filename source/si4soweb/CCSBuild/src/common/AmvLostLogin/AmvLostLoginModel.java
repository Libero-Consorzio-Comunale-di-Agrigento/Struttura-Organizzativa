//AmvLostLoginModel imports @1-AA37B184
package common.AmvLostLogin;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvLostLoginModel imports

//AmvLostLoginModel class head @1-7AEDB68A
public class AmvLostLoginModel extends com.codecharge.components.Page {
    public AmvLostLoginModel() {
        this( new CCSLocale(), null );
    }

    public AmvLostLoginModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvLostLoginModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvLostLoginModel class head

//page settings @1-8BAD423F
        super("AmvLostLogin", locale );
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

//LOSTLOGIN record @6-4B39D372
        
        /*
            Model of LOSTLOGIN record defining.
        */
        {
            com.codecharge.components.Record LOSTLOGIN = new com.codecharge.components.Record("LOSTLOGIN");
            LOSTLOGIN.setPageModel( this );
            LOSTLOGIN.addExcludeParam( "ccsForm" );
            LOSTLOGIN.setVisible( true );
            LOSTLOGIN.setAllowUpdate(false);
            LOSTLOGIN.setAllowDelete(false);
            LOSTLOGIN.setAllowRead(false);
            LOSTLOGIN.setPreserveType(PreserveParameterType.NONE);
            LOSTLOGIN.setReturnPage("AmvLostLogin" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox COGNOME__10 = new com.codecharge.components.TextBox("COGNOME", "", this );
            COGNOME__10.setType( com.codecharge.components.ControlType.TEXT );
            COGNOME__10.setHtmlEncode( true );
            LOSTLOGIN.add( COGNOME__10 );

            com.codecharge.components.TextBox NOME__11 = new com.codecharge.components.TextBox("NOME", "", this );
            NOME__11.setType( com.codecharge.components.ControlType.TEXT );
            NOME__11.setHtmlEncode( true );
            LOSTLOGIN.add( NOME__11 );

            com.codecharge.components.TextBox EMAIL__12 = new com.codecharge.components.TextBox("EMAIL", "", this );
            EMAIL__12.setType( com.codecharge.components.ControlType.TEXT );
            EMAIL__12.setHtmlEncode( true );
            LOSTLOGIN.add( EMAIL__12 );

            com.codecharge.components.Button InviaRichiesta__9 = new com.codecharge.components.Button("InviaRichiesta", this);
            InviaRichiesta__9.addExcludeParam( "ccsForm" );
            InviaRichiesta__9.addExcludeParam( "InviaRichiesta" );
            InviaRichiesta__9.setOperation( "Insert" );
            LOSTLOGIN.add( InviaRichiesta__9 );
            add(LOSTLOGIN);
        } // End definition of LOSTLOGIN record model.
//End LOSTLOGIN record

//AmvLostLoginModel class tail @1-F5FC18C5
    }
}
//End AmvLostLoginModel class tail
