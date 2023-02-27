//AdmRevisioniStoricoModel imports @1-A30EF813
package amvadm.AdmRevisioniStorico;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AdmRevisioniStoricoModel imports

//AdmRevisioniStoricoModel class head @1-A855E13B
public class AdmRevisioniStoricoModel extends com.codecharge.components.Page {
    public AdmRevisioniStoricoModel() {
        this( new CCSLocale(), null );
    }

    public AdmRevisioniStoricoModel(CCSLocale locale) {
        this( locale, null );
    }

    public AdmRevisioniStoricoModel( CCSLocale locale, HttpServletResponse response ) {
//End AdmRevisioniStoricoModel class head

//page settings @1-AFEFCA90
        super("AdmRevisioniStorico", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage Header__2 = new com.codecharge.components.IncludePage("Header", this );
            Header__2.setVisible( true );
            add( Header__2 );
            com.codecharge.components.IncludePage Left__3 = new com.codecharge.components.IncludePage("Left", this );
            Left__3.setVisible( true );
            add( Left__3 );
            com.codecharge.components.IncludePage Guida__5 = new com.codecharge.components.IncludePage("Guida", this );
            Guida__5.setVisible( true );
            add( Guida__5 );
            com.codecharge.components.IncludePage AdmDocumentoRevisioni__6 = new com.codecharge.components.IncludePage("AdmDocumentoRevisioni", this );
            AdmDocumentoRevisioni__6.setVisible( true );
            add( AdmDocumentoRevisioni__6 );
            com.codecharge.components.IncludePage Footer__4 = new com.codecharge.components.IncludePage("Footer", this );
            Footer__4.setVisible( true );
            add( Footer__4 );
        } // end page
//End page settings

//AdmRevisioniStoricoModel class tail @1-F5FC18C5
    }
}
//End AdmRevisioniStoricoModel class tail
