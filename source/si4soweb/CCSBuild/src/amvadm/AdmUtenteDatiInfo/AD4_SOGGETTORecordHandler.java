//AD4_SOGGETTOHandler Head @87-7D9724FB
package amvadm.AdmUtenteDatiInfo;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AD4_SOGGETTORecordHandler implements RecordListener {
//End AD4_SOGGETTOHandler Head

//BeforeShow Head @87-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @170-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

 if (e.getRecord().isEditMode()) {
 	e.getRecord().setVisible(false);
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @87-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @87-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @87-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @87-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @87-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @87-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @87-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @87-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @87-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @87-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @87-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @87-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @87-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @87-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @87-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @87-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @87-FCB6E20C
    }
//End AfterDelete Tail

//AD4_SOGGETTOHandler Tail @87-FCB6E20C
}
//End AD4_SOGGETTOHandler Tail

