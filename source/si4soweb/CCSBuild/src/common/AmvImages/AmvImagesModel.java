//AmvImagesModel imports @1-591B1973
package common.AmvImages;

import com.codecharge.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;

//End AmvImagesModel imports

//AmvImagesModel class head @1-AE839023
public class AmvImagesModel extends com.codecharge.components.Page {
    public AmvImagesModel() {
        this( new CCSLocale(), null );
    }

    public AmvImagesModel(CCSLocale locale) {
        this( locale, null );
    }

    public AmvImagesModel( CCSLocale locale, HttpServletResponse response ) {
//End AmvImagesModel class head

//page settings @1-E6659E6F
        super("AmvImages", locale );
        setResponse(response);
        {
        } // end page
//End page settings

//RecordImage record @2-A374D6BE
        
        /*
            Model of RecordImage record defining.
        */
        {
            com.codecharge.components.Record RecordImage = new com.codecharge.components.Record("RecordImage");
            RecordImage.setPageModel( this );
            RecordImage.addExcludeParam( "ccsForm" );
            RecordImage.setVisible( true );
            RecordImage.setPreserveType(PreserveParameterType.ALL);
            RecordImage.setReturnPage("AmvImages" + Names.ACTION_SUFFIX);
            RecordImage.addRecordListener(new RecordImageRecordHandler());

            com.codecharge.components.Label FILE_LIST_BOX__19 = new com.codecharge.components.Label("FILE_LIST_BOX", this);
            FILE_LIST_BOX__19.setType( com.codecharge.components.ControlType.TEXT );
            RecordImage.add(FILE_LIST_BOX__19);

            com.codecharge.components.Button Button_Insert__5 = new com.codecharge.components.Button("Button_Insert", this);
            Button_Insert__5.addExcludeParam( "ccsForm" );
            Button_Insert__5.addExcludeParam( "Button_Insert" );
            Button_Insert__5.setOperation( "Insert" );
            RecordImage.add( Button_Insert__5 );

            com.codecharge.components.Button Button1__9 = new com.codecharge.components.Button("Button1", this);
            Button1__9.addExcludeParam( "ccsForm" );
            Button1__9.addExcludeParam( "Button1" );
            RecordImage.add( Button1__9 );

            com.codecharge.components.Button Button2__20 = new com.codecharge.components.Button("Button2", this);
            Button2__20.addExcludeParam( "ccsForm" );
            Button2__20.addExcludeParam( "Button2" );
            RecordImage.add( Button2__20 );
            add(RecordImage);
        } // End definition of RecordImage record model.
//End RecordImage record

//AmvImagesModel class tail @1-F5FC18C5
    }
}
//End AmvImagesModel class tail

