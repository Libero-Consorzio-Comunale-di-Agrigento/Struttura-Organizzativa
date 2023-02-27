//AMV_VOCIHandler Head @35-8B1607E8
package amvadm.AdmMenu;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AMV_VOCIRecordHandler implements RecordListener {
//End AMV_VOCIHandler Head

//BeforeShow Head @35-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @35-D3448081
        if (! e.getRecord().isEditMode()) {
            e.getRecord().getControl("SM").setDefaultValue(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVSM"));
            e.getRecord().getControl("RUOLO").setDefaultValue(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVSR"));
            e.getRecord().getControl("AB").setDefaultValue(-2);
        }
//End Set values

//Event BeforeShow Action Custom Code @163-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVID") != null) {
	 if (!SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVID").equals("0")) {
	 	e.getRecord().setVisible(false);
	 } 
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @35-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @35-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @35-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @35-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @35-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @35-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @35-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @35-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @35-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @35-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @35-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @35-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @35-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @35-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @35-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @35-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @35-FCB6E20C
    }
//End AfterDelete Tail

//AMV_VOCIHandler Tail @35-FCB6E20C
}
//End AMV_VOCIHandler Tail

