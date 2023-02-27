//NUOVA_REVISIONERow: import @6-55FDE8FF
package amvadm.AdmRevisioneNuova;

import java.util.*;
import com.codecharge.db.*;
//End NUOVA_REVISIONERow: import

//NUOVA_REVISIONERow: class head @6-2FC06FC1
public class NUOVA_REVISIONERow {
//End NUOVA_REVISIONERow: class head

//NUOVA_REVISIONERow: declare fiels @6-B645A64E
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField DES_TIPOLOGIA = new TextField("DES_TIPOLOGIA", "DES_TIPOLOGIA");
    private TextField DES_CATEGORIA = new TextField("DES_CATEGORIA", "DES_CATEGORIA");
    private TextField DES_ARGOMENTO = new TextField("DES_ARGOMENTO", "DES_ARGOMENTO");
    private TextField NOME_AUTORE = new TextField("NOME_AUTORE", "NOME_AUTORE");
    private DateField DATA_INSERIMENTO = new DateField("DATA_INSERIMENTO", "DATA_INSERIMENTO");
    private DateField INIZIO_PUBBLICAZIONE_LABEL = new DateField("INIZIO_PUBBLICAZIONE_LABEL", "INIZIO_PUBBLICAZIONE");
    private DateField FINE_PUBBLICAZIONE_LABEL = new DateField("FINE_PUBBLICAZIONE_LABEL", "FINE_PUBBLICAZIONE");
    private TextField REDAZIONE = new TextField("REDAZIONE", "");
    private TextField VERIFICA = new TextField("VERIFICA", "");
    private TextField APPROVAZIONE = new TextField("APPROVAZIONE", "");
    private DateField INIZIO_PUBBLICAZIONE = new DateField("INIZIO_PUBBLICAZIONE", "");
    private DateField FINE_PUBBLICAZIONE = new DateField("FINE_PUBBLICAZIONE", "");
    private LongField REVISIONE = new LongField("REVISIONE", "REVISIONE");
    private LongField ID_DOCUMENTO = new LongField("ID_DOCUMENTO", "ID_DOCUMENTO");
//End NUOVA_REVISIONERow: declare fiels

//NUOVA_REVISIONERow: constructor @6-8C32FD36
    public NUOVA_REVISIONERow() {
    }
//End NUOVA_REVISIONERow: constructor

//NUOVA_REVISIONERow: method(s) of TITOLO @29-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of TITOLO

//NUOVA_REVISIONERow: method(s) of DES_TIPOLOGIA @30-46AC958F
    public TextField getDES_TIPOLOGIAField() {
        return DES_TIPOLOGIA;
    }

    public String getDES_TIPOLOGIA() {
        return DES_TIPOLOGIA.getValue();
    }

    public void setDES_TIPOLOGIA(String value) {
        this.DES_TIPOLOGIA.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of DES_TIPOLOGIA

//NUOVA_REVISIONERow: method(s) of DES_CATEGORIA @31-9D6C5AEF
    public TextField getDES_CATEGORIAField() {
        return DES_CATEGORIA;
    }

    public String getDES_CATEGORIA() {
        return DES_CATEGORIA.getValue();
    }

    public void setDES_CATEGORIA(String value) {
        this.DES_CATEGORIA.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of DES_CATEGORIA

//NUOVA_REVISIONERow: method(s) of DES_ARGOMENTO @32-8038D91F
    public TextField getDES_ARGOMENTOField() {
        return DES_ARGOMENTO;
    }

    public String getDES_ARGOMENTO() {
        return DES_ARGOMENTO.getValue();
    }

    public void setDES_ARGOMENTO(String value) {
        this.DES_ARGOMENTO.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of DES_ARGOMENTO

//NUOVA_REVISIONERow: method(s) of NOME_AUTORE @33-6173F572
    public TextField getNOME_AUTOREField() {
        return NOME_AUTORE;
    }

    public String getNOME_AUTORE() {
        return NOME_AUTORE.getValue();
    }

    public void setNOME_AUTORE(String value) {
        this.NOME_AUTORE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of NOME_AUTORE

//NUOVA_REVISIONERow: method(s) of DATA_INSERIMENTO @34-7D376105
    public DateField getDATA_INSERIMENTOField() {
        return DATA_INSERIMENTO;
    }

    public Date getDATA_INSERIMENTO() {
        return DATA_INSERIMENTO.getValue();
    }

    public void setDATA_INSERIMENTO(Date value) {
        this.DATA_INSERIMENTO.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of DATA_INSERIMENTO

//NUOVA_REVISIONERow: method(s) of INIZIO_PUBBLICAZIONE_LABEL @35-4FF2D58E
    public DateField getINIZIO_PUBBLICAZIONE_LABELField() {
        return INIZIO_PUBBLICAZIONE_LABEL;
    }

    public Date getINIZIO_PUBBLICAZIONE_LABEL() {
        return INIZIO_PUBBLICAZIONE_LABEL.getValue();
    }

    public void setINIZIO_PUBBLICAZIONE_LABEL(Date value) {
        this.INIZIO_PUBBLICAZIONE_LABEL.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of INIZIO_PUBBLICAZIONE_LABEL

//NUOVA_REVISIONERow: method(s) of FINE_PUBBLICAZIONE_LABEL @36-13CDFECF
    public DateField getFINE_PUBBLICAZIONE_LABELField() {
        return FINE_PUBBLICAZIONE_LABEL;
    }

    public Date getFINE_PUBBLICAZIONE_LABEL() {
        return FINE_PUBBLICAZIONE_LABEL.getValue();
    }

    public void setFINE_PUBBLICAZIONE_LABEL(Date value) {
        this.FINE_PUBBLICAZIONE_LABEL.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of FINE_PUBBLICAZIONE_LABEL

//NUOVA_REVISIONERow: method(s) of REDAZIONE @12-C46E031C
    public TextField getREDAZIONEField() {
        return REDAZIONE;
    }

    public String getREDAZIONE() {
        return REDAZIONE.getValue();
    }

    public void setREDAZIONE(String value) {
        this.REDAZIONE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of REDAZIONE

//NUOVA_REVISIONERow: method(s) of VERIFICA @17-CB8684D1
    public TextField getVERIFICAField() {
        return VERIFICA;
    }

    public String getVERIFICA() {
        return VERIFICA.getValue();
    }

    public void setVERIFICA(String value) {
        this.VERIFICA.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of VERIFICA

//NUOVA_REVISIONERow: method(s) of APPROVAZIONE @22-6ED877A7
    public TextField getAPPROVAZIONEField() {
        return APPROVAZIONE;
    }

    public String getAPPROVAZIONE() {
        return APPROVAZIONE.getValue();
    }

    public void setAPPROVAZIONE(String value) {
        this.APPROVAZIONE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of APPROVAZIONE

//NUOVA_REVISIONERow: method(s) of INIZIO_PUBBLICAZIONE @42-EA180E25
    public DateField getINIZIO_PUBBLICAZIONEField() {
        return INIZIO_PUBBLICAZIONE;
    }

    public Date getINIZIO_PUBBLICAZIONE() {
        return INIZIO_PUBBLICAZIONE.getValue();
    }

    public void setINIZIO_PUBBLICAZIONE(Date value) {
        this.INIZIO_PUBBLICAZIONE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of INIZIO_PUBBLICAZIONE

//NUOVA_REVISIONERow: method(s) of FINE_PUBBLICAZIONE @43-3D89441A
    public DateField getFINE_PUBBLICAZIONEField() {
        return FINE_PUBBLICAZIONE;
    }

    public Date getFINE_PUBBLICAZIONE() {
        return FINE_PUBBLICAZIONE.getValue();
    }

    public void setFINE_PUBBLICAZIONE(Date value) {
        this.FINE_PUBBLICAZIONE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of FINE_PUBBLICAZIONE

//NUOVA_REVISIONERow: method(s) of REVISIONE @41-AC7035B6
    public LongField getREVISIONEField() {
        return REVISIONE;
    }

    public Long getREVISIONE() {
        return REVISIONE.getValue();
    }

    public void setREVISIONE(Long value) {
        this.REVISIONE.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of REVISIONE

//NUOVA_REVISIONERow: method(s) of ID_DOCUMENTO @40-27EB5ACB
    public LongField getID_DOCUMENTOField() {
        return ID_DOCUMENTO;
    }

    public Long getID_DOCUMENTO() {
        return ID_DOCUMENTO.getValue();
    }

    public void setID_DOCUMENTO(Long value) {
        this.ID_DOCUMENTO.setValue(value);
    }
//End NUOVA_REVISIONERow: method(s) of ID_DOCUMENTO

//NUOVA_REVISIONERow: class tail @6-FCB6E20C
}
//End NUOVA_REVISIONERow: class tail

