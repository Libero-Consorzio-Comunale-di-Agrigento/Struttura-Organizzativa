//RICHIESTA_GRIDRow: import @39-FFE4BE57
package common.AmvRichiestaConferma;

import java.util.*;
import com.codecharge.db.*;
//End RICHIESTA_GRIDRow: import

//RICHIESTA_GRIDRow: class head @39-263C5FA7
public class RICHIESTA_GRIDRow {
//End RICHIESTA_GRIDRow: class head

//RICHIESTA_GRIDRow: declare fiels @39-435F0017
    private TextField TITOLO = new TextField("TITOLO", "TITOLO");
    private TextField STATO_FUTURO = new TextField("STATO_FUTURO", "STATO_FUTURO");
    private LongField ID_RICHIESTA = new LongField("ID_RICHIESTA", "ID_RICHIESTA");
    private TextField ELENCO_RICHIESTE_LINK = new TextField("ELENCO_RICHIESTE_LINK", "ELENCO_RICHIESTE_SRC");
    private TextField STAMPA_RICHIESTA = new TextField("STAMPA_RICHIESTA", "STAMPA_RICHIESTA_SRC");
    private TextField MODIFICA_RICHIESTA_LINK = new TextField("MODIFICA_RICHIESTA_LINK", "MODIFICA_RICHIESTA_SRC");
    private TextField CONFERMA_RICHIESTA_LINK = new TextField("CONFERMA_RICHIESTA_LINK", "CONFERMA_RICHIESTA_SRC");
    private TextField ELENCO_RICHIESTE_HREF = new TextField("ELENCO_RICHIESTE_HREF", "ELENCO_RICHIESTE_HREF");
    private TextField STAMPA_RICHIESTA_HREF = new TextField("STAMPA_RICHIESTA_HREF", "STAMPA_RICHIESTA_HREF");
    private TextField MODIFICA_RICHIESTA_HREF = new TextField("MODIFICA_RICHIESTA_HREF", "MODIFICA_RICHIESTA_HREF");
    private TextField CONFERMA_RICHIESTA_HREF = new TextField("CONFERMA_RICHIESTA_HREF", "CONFERMA_RICHIESTA_HREF");
//End RICHIESTA_GRIDRow: declare fiels

//RICHIESTA_GRIDRow: constructor @39-70D46A18
    public RICHIESTA_GRIDRow() {
    }
//End RICHIESTA_GRIDRow: constructor

//RICHIESTA_GRIDRow: method(s) of TITOLO @67-FB48796E
    public TextField getTITOLOField() {
        return TITOLO;
    }

    public String getTITOLO() {
        return TITOLO.getValue();
    }

    public void setTITOLO(String value) {
        this.TITOLO.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of TITOLO

//RICHIESTA_GRIDRow: method(s) of STATO_FUTURO @69-3D20FE0C
    public TextField getSTATO_FUTUROField() {
        return STATO_FUTURO;
    }

    public String getSTATO_FUTURO() {
        return STATO_FUTURO.getValue();
    }

    public void setSTATO_FUTURO(String value) {
        this.STATO_FUTURO.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of STATO_FUTURO

//RICHIESTA_GRIDRow: method(s) of ID_RICHIESTA @72-763FDCB5
    public LongField getID_RICHIESTAField() {
        return ID_RICHIESTA;
    }

    public Long getID_RICHIESTA() {
        return ID_RICHIESTA.getValue();
    }

    public void setID_RICHIESTA(Long value) {
        this.ID_RICHIESTA.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of ID_RICHIESTA

//RICHIESTA_GRIDRow: method(s) of ELENCO_RICHIESTE_LINK @61-8CB666C2
    public TextField getELENCO_RICHIESTE_LINKField() {
        return ELENCO_RICHIESTE_LINK;
    }

    public String getELENCO_RICHIESTE_LINK() {
        return ELENCO_RICHIESTE_LINK.getValue();
    }

    public void setELENCO_RICHIESTE_LINK(String value) {
        this.ELENCO_RICHIESTE_LINK.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of ELENCO_RICHIESTE_LINK

//RICHIESTA_GRIDRow: method(s) of STAMPA_RICHIESTA @71-471F5E64
    public TextField getSTAMPA_RICHIESTAField() {
        return STAMPA_RICHIESTA;
    }

    public String getSTAMPA_RICHIESTA() {
        return STAMPA_RICHIESTA.getValue();
    }

    public void setSTAMPA_RICHIESTA(String value) {
        this.STAMPA_RICHIESTA.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of STAMPA_RICHIESTA

//RICHIESTA_GRIDRow: method(s) of MODIFICA_RICHIESTA_LINK @62-FB7783C6
    public TextField getMODIFICA_RICHIESTA_LINKField() {
        return MODIFICA_RICHIESTA_LINK;
    }

    public String getMODIFICA_RICHIESTA_LINK() {
        return MODIFICA_RICHIESTA_LINK.getValue();
    }

    public void setMODIFICA_RICHIESTA_LINK(String value) {
        this.MODIFICA_RICHIESTA_LINK.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of MODIFICA_RICHIESTA_LINK

//RICHIESTA_GRIDRow: method(s) of CONFERMA_RICHIESTA_LINK @63-0FEF53A8
    public TextField getCONFERMA_RICHIESTA_LINKField() {
        return CONFERMA_RICHIESTA_LINK;
    }

    public String getCONFERMA_RICHIESTA_LINK() {
        return CONFERMA_RICHIESTA_LINK.getValue();
    }

    public void setCONFERMA_RICHIESTA_LINK(String value) {
        this.CONFERMA_RICHIESTA_LINK.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of CONFERMA_RICHIESTA_LINK

//RICHIESTA_GRIDRow: method(s) of ELENCO_RICHIESTE_HREF @ELENCO_RICHIESTE_HREF-B28EA4C8
    public TextField getELENCO_RICHIESTE_HREFField() {
        return ELENCO_RICHIESTE_HREF;
    }

    public String getELENCO_RICHIESTE_HREF() {
        return ELENCO_RICHIESTE_HREF.getValue();
    }

    public void setELENCO_RICHIESTE_HREF(String value) {
        this.ELENCO_RICHIESTE_HREF.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of ELENCO_RICHIESTE_HREF

//RICHIESTA_GRIDRow: method(s) of STAMPA_RICHIESTA_HREF @STAMPA_RICHIESTA_HREF-532BA266
    public TextField getSTAMPA_RICHIESTA_HREFField() {
        return STAMPA_RICHIESTA_HREF;
    }

    public String getSTAMPA_RICHIESTA_HREF() {
        return STAMPA_RICHIESTA_HREF.getValue();
    }

    public void setSTAMPA_RICHIESTA_HREF(String value) {
        this.STAMPA_RICHIESTA_HREF.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of STAMPA_RICHIESTA_HREF

//RICHIESTA_GRIDRow: method(s) of MODIFICA_RICHIESTA_HREF @MODIFICA_RICHIESTA_HREF-B17F2530
    public TextField getMODIFICA_RICHIESTA_HREFField() {
        return MODIFICA_RICHIESTA_HREF;
    }

    public String getMODIFICA_RICHIESTA_HREF() {
        return MODIFICA_RICHIESTA_HREF.getValue();
    }

    public void setMODIFICA_RICHIESTA_HREF(String value) {
        this.MODIFICA_RICHIESTA_HREF.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of MODIFICA_RICHIESTA_HREF

//RICHIESTA_GRIDRow: method(s) of CONFERMA_RICHIESTA_HREF @CONFERMA_RICHIESTA_HREF-45E7F55E
    public TextField getCONFERMA_RICHIESTA_HREFField() {
        return CONFERMA_RICHIESTA_HREF;
    }

    public String getCONFERMA_RICHIESTA_HREF() {
        return CONFERMA_RICHIESTA_HREF.getValue();
    }

    public void setCONFERMA_RICHIESTA_HREF(String value) {
        this.CONFERMA_RICHIESTA_HREF.setValue(value);
    }
//End RICHIESTA_GRIDRow: method(s) of CONFERMA_RICHIESTA_HREF

//RICHIESTA_GRIDRow: class tail @39-FCB6E20C
}
//End RICHIESTA_GRIDRow: class tail

