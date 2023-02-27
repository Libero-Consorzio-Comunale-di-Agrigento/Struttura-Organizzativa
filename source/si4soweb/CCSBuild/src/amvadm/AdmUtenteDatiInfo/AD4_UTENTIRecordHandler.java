//AD4_UTENTIHandler Head @59-AF78DCD5
package amvadm.AdmUtenteDatiInfo;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AD4_UTENTIRecordHandler implements RecordListener {
//End AD4_UTENTIHandler Head

//BeforeShow Head @59-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @86-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 	String mvute = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVUTE").toString();
	if (mvute == null) {
		e.getRecord().setVisible(false);
	}
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @59-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @59-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @59-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @59-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @59-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @59-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @59-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @59-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @59-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @59-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @59-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @59-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @59-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @59-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @59-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @59-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @59-FCB6E20C
    }
//End AfterDelete Tail

//AD4_UTENTIHandler Tail @59-FCB6E20C
}
//End AD4_UTENTIHandler Tail

