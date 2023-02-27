//AMV_GUIDE1Handler Head @19-B480CFA9
package amvadm.AdmGuide;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AMV_GUIDE1RecordHandler implements RecordListener {
//End AMV_GUIDE1Handler Head

//BeforeShow Head @19-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @19-931B604B
        if (! e.getRecord().isEditMode()) {
            e.getRecord().getControl("GUIDA").setDefaultValue(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Id"));
            e.getRecord().getControl("ALIAS").setDefaultValue("web");
        }
//End Set values

//BeforeShow Tail @19-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @19-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @19-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @19-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @19-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @19-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @19-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @19-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @19-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @19-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @19-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @19-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @19-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @19-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @19-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @19-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @19-FCB6E20C
    }
//End AfterDelete Tail

//AMV_GUIDE1Handler Tail @19-FCB6E20C
}
//End AMV_GUIDE1Handler Tail

