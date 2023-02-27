//AMV_SEZIONE_RECORDRow: import @2-1C3FB95E
package amvadm.AdmSezione;

import java.util.*;
import com.codecharge.db.*;
//End AMV_SEZIONE_RECORDRow: import

//AMV_SEZIONE_RECORDRow: class head @2-BD9B11B5
public class AMV_SEZIONE_RECORDRow {
//End AMV_SEZIONE_RECORDRow: class head

//AMV_SEZIONE_RECORDRow: declare fiels @2-9C188B48
    private TextField NOME = new TextField("NOME", "NOME");
    private TextField DESCRIZIONE = new TextField("DESCRIZIONE", "DESCRIZIONE");
    private TextField ID_PADRE = new TextField("ID_PADRE", "ID_PADRE");
    private LongField SEQUENZA = new LongField("SEQUENZA", "SEQUENZA");
    private LongField ID_AREA = new LongField("ID_AREA", "ID_AREA");
    private TextField VISIBILITA = new TextField("VISIBILITA", "VISIBILITA");
    private TextField ZONA_ESPANSIONE = new TextField("ZONA_ESPANSIONE", "ZONA_ESPANSIONE");
    private TextField ZONA_TIPO = new TextField("ZONA_TIPO", "ZONA_TIPO");
    private TextField ZONA = new TextField("ZONA", "ZONA");
    private TextField ZONA_VISIBILITA = new TextField("ZONA_VISIBILITA", "ZONA_VISIBILITA");
    private TextField ZONA_FORMATO = new TextField("ZONA_FORMATO", "ZONA_FORMATO");
    private TextField IMMAGINE = new TextField("IMMAGINE", "IMMAGINE");
    private LongField MAX_VIS = new LongField("MAX_VIS", "MAX_VIS");
    private TextField ICONA = new TextField("ICONA", "ICONA");
    private TextField INTESTAZIONE = new TextField("INTESTAZIONE", "INTESTAZIONE");
    private TextField LOGO_SX = new TextField("LOGO_SX", "LOGO_SX");
    private TextField LOGO_SX_LINK = new TextField("LOGO_SX_LINK", "LOGO_SX_LINK");
    private TextField LOGO_DX = new TextField("LOGO_DX", "LOGO_DX");
    private TextField LOGO_DX_LINK = new TextField("LOGO_DX_LINK", "LOGO_DX_LINK");
    private TextField STYLE = new TextField("STYLE", "STYLE");
    private TextField COPYRIGHT = new TextField("COPYRIGHT", "COPYRIGHT");
    private LongField ID_SEZIONE = new LongField("ID_SEZIONE", "ID_SEZIONE");
//End AMV_SEZIONE_RECORDRow: declare fiels

//AMV_SEZIONE_RECORDRow: constructor @2-A2681F65
    public AMV_SEZIONE_RECORDRow() {
    }
//End AMV_SEZIONE_RECORDRow: constructor

//AMV_SEZIONE_RECORDRow: method(s) of NOME @3-DBA8086C
    public TextField getNOMEField() {
        return NOME;
    }

    public String getNOME() {
        return NOME.getValue();
    }

    public void setNOME(String value) {
        this.NOME.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of NOME

//AMV_SEZIONE_RECORDRow: method(s) of DESCRIZIONE @4-07D33E44
    public TextField getDESCRIZIONEField() {
        return DESCRIZIONE;
    }

    public String getDESCRIZIONE() {
        return DESCRIZIONE.getValue();
    }

    public void setDESCRIZIONE(String value) {
        this.DESCRIZIONE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of DESCRIZIONE

//AMV_SEZIONE_RECORDRow: method(s) of ID_PADRE @5-706D3D2C
    public TextField getID_PADREField() {
        return ID_PADRE;
    }

    public String getID_PADRE() {
        return ID_PADRE.getValue();
    }

    public void setID_PADRE(String value) {
        this.ID_PADRE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ID_PADRE

//AMV_SEZIONE_RECORDRow: method(s) of SEQUENZA @8-E6112114
    public LongField getSEQUENZAField() {
        return SEQUENZA;
    }

    public Long getSEQUENZA() {
        return SEQUENZA.getValue();
    }

    public void setSEQUENZA(Long value) {
        this.SEQUENZA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of SEQUENZA

//AMV_SEZIONE_RECORDRow: method(s) of ID_AREA @33-0DE84566
    public LongField getID_AREAField() {
        return ID_AREA;
    }

    public Long getID_AREA() {
        return ID_AREA.getValue();
    }

    public void setID_AREA(Long value) {
        this.ID_AREA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ID_AREA

//AMV_SEZIONE_RECORDRow: method(s) of VISIBILITA @31-70FAA02F
    public TextField getVISIBILITAField() {
        return VISIBILITA;
    }

    public String getVISIBILITA() {
        return VISIBILITA.getValue();
    }

    public void setVISIBILITA(String value) {
        this.VISIBILITA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of VISIBILITA

//AMV_SEZIONE_RECORDRow: method(s) of ZONA_ESPANSIONE @30-99535222
    public TextField getZONA_ESPANSIONEField() {
        return ZONA_ESPANSIONE;
    }

    public String getZONA_ESPANSIONE() {
        return ZONA_ESPANSIONE.getValue();
    }

    public void setZONA_ESPANSIONE(String value) {
        this.ZONA_ESPANSIONE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ZONA_ESPANSIONE

//AMV_SEZIONE_RECORDRow: method(s) of ZONA_TIPO @27-FF7E8727
    public TextField getZONA_TIPOField() {
        return ZONA_TIPO;
    }

    public String getZONA_TIPO() {
        return ZONA_TIPO.getValue();
    }

    public void setZONA_TIPO(String value) {
        this.ZONA_TIPO.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ZONA_TIPO

//AMV_SEZIONE_RECORDRow: method(s) of ZONA @7-EEFA4AA2
    public TextField getZONAField() {
        return ZONA;
    }

    public String getZONA() {
        return ZONA.getValue();
    }

    public void setZONA(String value) {
        this.ZONA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ZONA

//AMV_SEZIONE_RECORDRow: method(s) of ZONA_VISIBILITA @29-6A19C690
    public TextField getZONA_VISIBILITAField() {
        return ZONA_VISIBILITA;
    }

    public String getZONA_VISIBILITA() {
        return ZONA_VISIBILITA.getValue();
    }

    public void setZONA_VISIBILITA(String value) {
        this.ZONA_VISIBILITA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ZONA_VISIBILITA

//AMV_SEZIONE_RECORDRow: method(s) of ZONA_FORMATO @28-9B65CB44
    public TextField getZONA_FORMATOField() {
        return ZONA_FORMATO;
    }

    public String getZONA_FORMATO() {
        return ZONA_FORMATO.getValue();
    }

    public void setZONA_FORMATO(String value) {
        this.ZONA_FORMATO.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ZONA_FORMATO

//AMV_SEZIONE_RECORDRow: method(s) of IMMAGINE @10-D0029DDF
    public TextField getIMMAGINEField() {
        return IMMAGINE;
    }

    public String getIMMAGINE() {
        return IMMAGINE.getValue();
    }

    public void setIMMAGINE(String value) {
        this.IMMAGINE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of IMMAGINE

//AMV_SEZIONE_RECORDRow: method(s) of MAX_VIS @9-F19BF571
    public LongField getMAX_VISField() {
        return MAX_VIS;
    }

    public Long getMAX_VIS() {
        return MAX_VIS.getValue();
    }

    public void setMAX_VIS(Long value) {
        this.MAX_VIS.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of MAX_VIS

//AMV_SEZIONE_RECORDRow: method(s) of ICONA @43-51B27CAD
    public TextField getICONAField() {
        return ICONA;
    }

    public String getICONA() {
        return ICONA.getValue();
    }

    public void setICONA(String value) {
        this.ICONA.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ICONA

//AMV_SEZIONE_RECORDRow: method(s) of INTESTAZIONE @36-FDC49E10
    public TextField getINTESTAZIONEField() {
        return INTESTAZIONE;
    }

    public String getINTESTAZIONE() {
        return INTESTAZIONE.getValue();
    }

    public void setINTESTAZIONE(String value) {
        this.INTESTAZIONE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of INTESTAZIONE

//AMV_SEZIONE_RECORDRow: method(s) of LOGO_SX @37-E602EFA2
    public TextField getLOGO_SXField() {
        return LOGO_SX;
    }

    public String getLOGO_SX() {
        return LOGO_SX.getValue();
    }

    public void setLOGO_SX(String value) {
        this.LOGO_SX.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of LOGO_SX

//AMV_SEZIONE_RECORDRow: method(s) of LOGO_SX_LINK @38-CC4DF3FE
    public TextField getLOGO_SX_LINKField() {
        return LOGO_SX_LINK;
    }

    public String getLOGO_SX_LINK() {
        return LOGO_SX_LINK.getValue();
    }

    public void setLOGO_SX_LINK(String value) {
        this.LOGO_SX_LINK.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of LOGO_SX_LINK

//AMV_SEZIONE_RECORDRow: method(s) of LOGO_DX @39-C71637ED
    public TextField getLOGO_DXField() {
        return LOGO_DX;
    }

    public String getLOGO_DX() {
        return LOGO_DX.getValue();
    }

    public void setLOGO_DX(String value) {
        this.LOGO_DX.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of LOGO_DX

//AMV_SEZIONE_RECORDRow: method(s) of LOGO_DX_LINK @40-4256F283
    public TextField getLOGO_DX_LINKField() {
        return LOGO_DX_LINK;
    }

    public String getLOGO_DX_LINK() {
        return LOGO_DX_LINK.getValue();
    }

    public void setLOGO_DX_LINK(String value) {
        this.LOGO_DX_LINK.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of LOGO_DX_LINK

//AMV_SEZIONE_RECORDRow: method(s) of STYLE @41-D7AC42FF
    public TextField getSTYLEField() {
        return STYLE;
    }

    public String getSTYLE() {
        return STYLE.getValue();
    }

    public void setSTYLE(String value) {
        this.STYLE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of STYLE

//AMV_SEZIONE_RECORDRow: method(s) of COPYRIGHT @42-B94507BB
    public TextField getCOPYRIGHTField() {
        return COPYRIGHT;
    }

    public String getCOPYRIGHT() {
        return COPYRIGHT.getValue();
    }

    public void setCOPYRIGHT(String value) {
        this.COPYRIGHT.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of COPYRIGHT

//AMV_SEZIONE_RECORDRow: method(s) of ID_SEZIONE @15-87BE2FDD
    public LongField getID_SEZIONEField() {
        return ID_SEZIONE;
    }

    public Long getID_SEZIONE() {
        return ID_SEZIONE.getValue();
    }

    public void setID_SEZIONE(Long value) {
        this.ID_SEZIONE.setValue(value);
    }
//End AMV_SEZIONE_RECORDRow: method(s) of ID_SEZIONE

//AMV_SEZIONE_RECORDRow: class tail @2-FCB6E20C
}
//End AMV_SEZIONE_RECORDRow: class tail

