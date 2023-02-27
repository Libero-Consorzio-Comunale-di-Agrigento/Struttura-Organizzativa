//AD4_ACCESSISearchHandler Head @30-1C5045A4
package amvadm.AdmAccessi;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class AD4_ACCESSISearchRecordHandler implements RecordListener {
//End AD4_ACCESSISearchHandler Head

//BeforeShow Head @30-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @30-37AA9761
        if (! e.getRecord().isEditMode()) {
            e.getRecord().getControl("DAL").setDefaultValue(java.util.Calendar.getInstance().getTime());
            e.getRecord().getControl("AL").setDefaultValue(java.util.Calendar.getInstance().getTime());
        }
//End Set values

//BeforeShow Tail @30-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @30-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @30-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @30-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @30-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @30-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @30-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @30-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @30-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @30-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @30-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @30-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @30-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @30-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @30-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @30-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @30-FCB6E20C
    }
//End AfterDelete Tail

//AD4_ACCESSISearchHandler Tail @30-FCB6E20C
}
//End AD4_ACCESSISearchHandler Tail

