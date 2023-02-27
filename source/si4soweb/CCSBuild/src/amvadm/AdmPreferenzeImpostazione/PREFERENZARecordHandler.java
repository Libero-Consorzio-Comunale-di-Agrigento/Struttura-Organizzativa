//PREFERENZAHandler Head @17-27AEFC8F
package amvadm.AdmPreferenzeImpostazione;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
public class PREFERENZARecordHandler implements RecordListener {
//End PREFERENZAHandler Head

//BeforeShow Head @17-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Event BeforeShow Action Custom Code @29-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
if (!(e.getRecord().isEditMode())) {
 e.getRecord().setVisible(false);
}

//End Event BeforeShow Action Custom Code

//BeforeShow Tail @17-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @17-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//OnValidate Tail @17-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @17-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @17-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @17-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @17-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @17-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//AfterInsert Tail @17-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @17-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @17-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @17-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//AfterUpdate Tail @17-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @17-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @17-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @17-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @17-FCB6E20C
    }
//End AfterDelete Tail

//PREFERENZAHandler Tail @17-FCB6E20C
}
//End PREFERENZAHandler Tail

