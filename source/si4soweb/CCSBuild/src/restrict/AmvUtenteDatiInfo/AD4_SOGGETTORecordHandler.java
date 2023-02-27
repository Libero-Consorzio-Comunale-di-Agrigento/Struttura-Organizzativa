//AD4_SOGGETTOHandler Head @52-D0408F4F
package restrict.AmvUtenteDatiInfo;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AD4_SOGGETTORecordHandler implements RecordListener {
//End AD4_SOGGETTOHandler Head

//BeforeShow Head @52-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @52-6F5F1117
        if (! e.getRecord().isEditMode()) {
            e.getRecord().getControl("STATO_NASCITA").setDefaultValue(100);
        }
//End Set values

//Event BeforeShow Action Custom Code @71-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getRecord().isEditMode()) {
 	e.getRecord().setVisible(false);	
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @52-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @52-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @52-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @52-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @52-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @52-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @52-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @52-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @52-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @52-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @52-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @52-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @52-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @52-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @52-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @52-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @52-FCB6E20C
    }
//End AfterDelete Tail

//AD4_SOGGETTOHandler Tail @52-FCB6E20C
}
//End AD4_SOGGETTOHandler Tail

