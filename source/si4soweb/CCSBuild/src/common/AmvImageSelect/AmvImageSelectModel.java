//AmvImageSelectModel imports @1-6FA6032D
package common.AmvImageSelect;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvImageSelectModel imports

//AmvImageSelectModel class head @1-BD20AABF
public class AmvImageSelectModel extends com.codecharge.components.Page {
    public AmvImageSelectModel() {
        this( new CCSLocale(), null );
    }

    public AmvImageSelectModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvImageSelectModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvImageSelectModel class head

//page settings @1-53F0E966
        super("AmvImageSelect", locale );
        setResponse(response);
        {
            com.codecharge.components.IncludePage AmvStyle__14 = new com.codecharge.components.IncludePage("AmvStyle", this );
            AmvStyle__14.setVisible( true );
            add( AmvStyle__14 );
        } // end page
//End page settings

//FILE_LIST record @2-F73C12C2
        
        /*
            Model of FILE_LIST record defining.
        */
        {
            com.codecharge.components.Record FILE_LIST = new com.codecharge.components.Record("FILE_LIST");
            FILE_LIST.setPageModel( this );
            FILE_LIST.addExcludeParam( "ccsForm" );
            FILE_LIST.setVisible( true );
            FILE_LIST.setAllowInsert(false);
            FILE_LIST.setAllowDelete(false);
            FILE_LIST.setPreserveType(PreserveParameterType.GET);
            FILE_LIST.setReturnPage("AmvImageSelect" + Names.ACTION_SUFFIX);
            FILE_LIST.addRecordListener(new FILE_LISTRecordHandler());

            com.codecharge.components.Label TITOLO__10 = new com.codecharge.components.Label("TITOLO", "TITOLO", this );
            TITOLO__10.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(TITOLO__10);

            com.codecharge.components.Label MVIF__17 = new com.codecharge.components.Label("MVIF", "MVIF", this );
            MVIF__17.setType( com.codecharge.components.ControlType.TEXT );
            MVIF__17.setHtmlEncode( true );
            MVIF__17.addControlListener( new FILE_LISTMVIFHandler());
            FILE_LIST.add(MVIF__17);

            com.codecharge.components.Label FILE_LIST_BOX__13 = new com.codecharge.components.Label("FILE_LIST_BOX", this);
            FILE_LIST_BOX__13.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(FILE_LIST_BOX__13);

            com.codecharge.components.Label INPUT_FILE__19 = new com.codecharge.components.Label("INPUT_FILE", "INPUT_FILE", this );
            INPUT_FILE__19.setType( com.codecharge.components.ControlType.TEXT );
            FILE_LIST.add(INPUT_FILE__19);

            com.codecharge.components.Hidden MOSTRA__20 = new com.codecharge.components.Hidden("MOSTRA", "MOSTRA", this );
            MOSTRA__20.setType( com.codecharge.components.ControlType.TEXT );
            MOSTRA__20.setHtmlEncode( true );
            FILE_LIST.add( MOSTRA__20 );

            com.codecharge.components.Button Button_Update__6 = new com.codecharge.components.Button("Button_Update", this);
            Button_Update__6.addExcludeParam( "ccsForm" );
            Button_Update__6.addExcludeParam( "Button_Update" );
            Button_Update__6.setOperation( "Update" );
            FILE_LIST.add( Button_Update__6 );

            com.codecharge.components.Button Annulla__11 = new com.codecharge.components.Button("Annulla", this);
            Annulla__11.addExcludeParam( "ccsForm" );
            Annulla__11.addExcludeParam( "Annulla" );
            Annulla__11.setOperation( "Cancel" );
            FILE_LIST.add( Annulla__11 );
            add(FILE_LIST);
        } // End definition of FILE_LIST record model.
//End FILE_LIST record

//AmvImageSelectModel class tail @1-F5FC18C5
    }
}
//End AmvImageSelectModel class tail
