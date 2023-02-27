//AmvRichiestaAbilitazioneModel imports @1-493C1823
package common.AmvRichiestaAbilitazione;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvRichiestaAbilitazioneModel imports

//AmvRichiestaAbilitazioneModel class head @1-249120B7
public class AmvRichiestaAbilitazioneModel extends com.codecharge.components.Page {
    public AmvRichiestaAbilitazioneModel() {
        this( new CCSLocale(), null );
    }

    public AmvRichiestaAbilitazioneModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvRichiestaAbilitazioneModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvRichiestaAbilitazioneModel class head

//page settings @1-D95F9B70
        super("AmvRichiestaAbilitazione", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//AD4_RICHIESTA record @2-146EC02B
        
        /*
            Model of AD4_RICHIESTA record defining.
        */
        {
            com.codecharge.components.Record AD4_RICHIESTA = new com.codecharge.components.Record("AD4_RICHIESTA");
            AD4_RICHIESTA.setPageModel( this );
            AD4_RICHIESTA.addExcludeParam( "ccsForm" );
            AD4_RICHIESTA.setVisible( true );
            AD4_RICHIESTA.setAllowDelete(false);
            AD4_RICHIESTA.setPreserveType(PreserveParameterType.GET);
            AD4_RICHIESTA.setReturnPage("AmvRichiestaAbilitazione" + Names.ACTION_SUFFIX);

            com.codecharge.components.TextBox TextBox1__15 = new com.codecharge.components.TextBox("TextBox1", "DUMMY", this );
            TextBox1__15.setType( com.codecharge.components.ControlType.TEXT );
            TextBox1__15.setHtmlEncode( true );
            AD4_RICHIESTA.add( TextBox1__15 );

            com.codecharge.components.Button Insert__5 = new com.codecharge.components.Button("Insert", this);
            Insert__5.addExcludeParam( "ccsForm" );
            Insert__5.addExcludeParam( "Insert" );
            Insert__5.setOperation( "Insert" );
            AD4_RICHIESTA.add( Insert__5 );
            add(AD4_RICHIESTA);
        } // End definition of AD4_RICHIESTA record model.
//End AD4_RICHIESTA record

//AmvRichiestaAbilitazioneModel class tail @1-F5FC18C5
    }
}
//End AmvRichiestaAbilitazioneModel class tail

