//FILE_LISTDATASOURCEHandler Head @37-8372A938
package common.AmvAttachSelect;
import java.util.*;
import com.codecharge.events.*;
import com.codecharge.components.*;
import com.codecharge.validation.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
public class FILE_LISTDATASOURCEHandler implements ValidationListener {
//End FILE_LISTDATASOURCEHandler Head

//OnValidate Head @37-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @37-FCB6E20C
    }
//End OnValidate Tail

//BeforeShow Head @37-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Retrieve Value for Control @38-B879086F
        ((com.codecharge.components.Hidden) ((com.codecharge.components.Record) (e.getPage().getChild( "FILE_LIST" ))).getChild( "DATASOURCE" )).setValue( SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDATASOURCE") );
//End Event BeforeShow Action Retrieve Value for Control

//BeforeShow Tail @37-FCB6E20C
    }
//End BeforeShow Tail

//FILE_LISTDATASOURCEHandler Tail @37-FCB6E20C
}
//End FILE_LISTDATASOURCEHandler Tail

