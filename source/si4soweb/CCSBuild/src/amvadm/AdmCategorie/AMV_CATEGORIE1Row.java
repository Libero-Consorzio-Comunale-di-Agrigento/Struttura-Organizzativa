//AMV_CATEGORIE1Row: import @11-DD4D1B0C
package amvadm.AdmCategorie;

import java.util.*;
import com.codecharge.db.*;
//End AMV_CATEGORIE1Row: import

//AMV_CATEGORIE1Row: class head @11-6DCEA2CF
public class AMV_CATEGORIE1Row {
//End AMV_CATEGORIE1Row: class head

//AMV_CATEGORIE1Row: declare fiels @11-5006B82E
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private LongField ID_CATEGORIA = new LongField("ID_CATEGORIA", "ID_CATEGORIA");
//End AMV_CATEGORIE1Row: declare fiels

//AMV_CATEGORIE1Row: constructor @11-C4B1FC0B
    public AMV_CATEGORIE1Row() {
    }
//End AMV_CATEGORIE1Row: constructor

//AMV_CATEGORIE1Row: method(s) of NOME @13-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_CATEGORIE1Row: method(s) of NOME

//AMV_CATEGORIE1Row: method(s) of DESCRIZIONE @15-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_CATEGORIE1Row: method(s) of DESCRIZIONE

//AMV_CATEGORIE1Row: method(s) of ID_CATEGORIA @20-B7640A0C
    public LongField getID_CATEGORIAField() {
        return ID_CATEGORIA;
    }

    public Long getID_CATEGORIA() {
        return ID_CATEGORIA.getValue();
    }

    public void setID_CATEGORIA(Long value) {
        this.ID_CATEGORIA.setValue(value);
    }
//End AMV_CATEGORIE1Row: method(s) of ID_CATEGORIA

//AMV_CATEGORIE1Row: class tail @11-FCB6E20C
}
//End AMV_CATEGORIE1Row: class tail

