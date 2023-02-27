//PARAMETRIRow: import @6-7EB9CF32
package amvadm.AdmRichiestaParametri;

import java.util.*;
import com.codecharge.db.*;
//End PARAMETRIRow: import

//PARAMETRIRow: class head @6-B8FADBC0
public class PARAMETRIRow {
//End PARAMETRIRow: class head

//PARAMETRIRow: declare fiels @6-A1FD5917
    private TextField NOME = new TextField("NOME", "TITOLO");
    private TextField VALORE = new TextField("VALORE", "VALORE");
    private TextField NOME_PAR = new TextField("NOME_PAR", "NOME_PAR");
    private TextField ID_RIC = new TextField("ID_RIC", "ID_RIC");
    private BooleanField CheckBox_Delete = new BooleanField("CheckBox_Delete", "CheckBox_Delete");
//End PARAMETRIRow: declare fiels

//PARAMETRIRow: constructor @6-CFDBF32C
    public PARAMETRIRow() {
    }
//End PARAMETRIRow: constructor

//PARAMETRIRow: method(s) of NOME @7-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End PARAMETRIRow: method(s) of NOME

//PARAMETRIRow: method(s) of VALORE @8-BC514AA0
    public TextField getVALOREField() {
        return VALORE;
    }

    public String getVALORE() {
        return VALORE.getValue();
    }

    public void setVALORE(String value) {
        this.VALORE.setValue(value);
    }
//End PARAMETRIRow: method(s) of VALORE

//PARAMETRIRow: method(s) of NOME_PAR @9-6DE798A9
    public TextField getNOME_PARField() {
        return NOME_PAR;
    }

    public String getNOME_PAR() {
        return NOME_PAR.getValue();
    }

    public void setNOME_PAR(String value) {
        this.NOME_PAR.setValue(value);
    }
//End PARAMETRIRow: method(s) of NOME_PAR

//PARAMETRIRow: method(s) of ID_RIC @10-D9DC9BD1
    public TextField getID_RICField() {
        return ID_RIC;
    }

    public String getID_RIC() {
        return ID_RIC.getValue();
    }

    public void setID_RIC(String value) {
        this.ID_RIC.setValue(value);
    }
//End PARAMETRIRow: method(s) of ID_RIC

//PARAMETRIRow: method(s) of CheckBox_Delete @11-AA882109
    public BooleanField getCheckBox_DeleteField() {
        return CheckBox_Delete;
    }

    public Boolean getCheckBox_Delete() {
        return CheckBox_Delete.getValue();
    }

    public void setCheckBox_Delete(Boolean value) {
        this.CheckBox_Delete.setValue(value);
    }
//End PARAMETRIRow: method(s) of CheckBox_Delete

//PARAMETRIRow: isDeleted @$id-FBA9727F
    boolean rowIsApply = true;
    boolean rowIsNew;
    boolean rowIsDeleted;

    public boolean isApply() { return rowIsApply; }
    public void setApply(boolean apply) { this.rowIsApply = apply; }

    public boolean isNew() { return rowIsNew; }
    public void setNew(boolean deleted) { this.rowIsNew = deleted; }

    public boolean isDeleted() { return rowIsDeleted; }
    public void setDeleted(boolean deleted) { this.rowIsDeleted = deleted; }
//End PARAMETRIRow: isDeleted

//CCSCachedColumns @$id-0CB8C20D
    ArrayList CCSCachedColumns = new ArrayList();

    public ArrayList getCCSCachedColumns() {
        return CCSCachedColumns;
    }

    public void setCCSCachedColumns(ArrayList columns) {
        CCSCachedColumns = columns;
    }

    public com.codecharge.components.CachedColumn getCCSCachedColumn(String name) {
        com.codecharge.components.CachedColumn column = null;
        if (com.codecharge.util.StringUtils.isEmpty(name)) return column;
        for (int i = 0; i < CCSCachedColumns.size(); i++ ) {
            com.codecharge.components.CachedColumn c = (com.codecharge.components.CachedColumn) CCSCachedColumns.get(i);
            if ( name.equals(c.getName()) ) {
                column = c;
                break;
            }
        }
        return column;
    }
//End CCSCachedColumns

//PARAMETRIRow: class tail @6-FCB6E20C
}
//End PARAMETRIRow: class tail

