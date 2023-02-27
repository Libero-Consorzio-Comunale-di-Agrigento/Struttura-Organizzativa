/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   21/03/2005   AO   Gestione parametri di output della procedure in Insert
******************************************************************************/
//AMV_DOCUMENTI DataSource @5-56E149B3
package amvadm.AdmDocumento;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DOCUMENTI DataSource

//class DataObject Header @5-F6B25D57
public class AMV_DOCUMENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-FE1B940C
    

    DoubleField urlP_ID_DOCUMENTO = new DoubleField(null, null);
    
    DoubleField postID_TIPOLOGIA = new DoubleField(null, null);
    
    DoubleField postID_CATEGORIA = new DoubleField(null, null);
    
    DoubleField postID_ARGOMENTO = new DoubleField(null, null);
    
    DoubleField postID_RILEVANZA = new DoubleField(null, null);
    
    DoubleField postID_AREA = new DoubleField(null, null);
    
    TextField postTITOLO = new TextField(null, null);
    
    TextField postTIPO_TESTO = new TextField(null, null);
    
    TextField urlTESTO = new TextField(null, null);
    
    TextField ctrlABSTRACT = new TextField(null, null);
    
    TextField ctrlLINK = new TextField(null, null);
    
    TextField postIMMAGINE = new TextField(null, null);
    
    TextField postICONA = new TextField(null, null);
    
    DateField postDATA_RIFERIMENTO = new DateField(null, null);
    
    DateField postINIZIO_PUBBLICAZIONE = new DateField(null, null);
    
    DateField postFINE_PUBBLICAZIONE = new DateField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    DoubleField postREVISIONE = new DoubleField(null, null);
    
    DoubleField postID_SEZIONE = new DoubleField(null, null);
    
    DoubleField postSEQUENZA = new DoubleField(null, null);
    
    DoubleField postID_DOCUMENTO = new DoubleField(null, null);
    
    TextField ctrlICONA = new TextField(null, null);
    
    LongField postALLEGATO = new LongField(null, null);
    
    TextField postSTATO = new TextField(null, null);
    
    DoubleField urlID = new DoubleField(null, null);
    
    TextField postLINK = new TextField(null, null);
    
    LongField urlREV = new LongField(null, null);
    

    private AMV_DOCUMENTIRow row = new AMV_DOCUMENTIRow();

//End attributes of DataObject

//properties of DataObject @5-E8E31801

    public void  setUrlP_ID_DOCUMENTO( double param ) {
        this.urlP_ID_DOCUMENTO.setValue( param );
    }

    public void  setUrlP_ID_DOCUMENTO( double param, Format ignore ) throws java.text.ParseException {
        this.urlP_ID_DOCUMENTO.setValue( param );
    }

    public void  setUrlP_ID_DOCUMENTO( Object param, Format format ) throws java.text.ParseException {
        this.urlP_ID_DOCUMENTO.setValue( param, format );
    }

    public void  setUrlP_ID_DOCUMENTO( Double param ) {
        this.urlP_ID_DOCUMENTO.setValue( param );
    }

    public void  setPostID_TIPOLOGIA( double param ) {
        this.postID_TIPOLOGIA.setValue( param );
    }

    public void  setPostID_TIPOLOGIA( double param, Format ignore ) throws java.text.ParseException {
        this.postID_TIPOLOGIA.setValue( param );
    }

    public void  setPostID_TIPOLOGIA( Object param, Format format ) throws java.text.ParseException {
        this.postID_TIPOLOGIA.setValue( param, format );
    }

    public void  setPostID_TIPOLOGIA( Double param ) {
        this.postID_TIPOLOGIA.setValue( param );
    }

    public void  setPostID_CATEGORIA( double param ) {
        this.postID_CATEGORIA.setValue( param );
    }

    public void  setPostID_CATEGORIA( double param, Format ignore ) throws java.text.ParseException {
        this.postID_CATEGORIA.setValue( param );
    }

    public void  setPostID_CATEGORIA( Object param, Format format ) throws java.text.ParseException {
        this.postID_CATEGORIA.setValue( param, format );
    }

    public void  setPostID_CATEGORIA( Double param ) {
        this.postID_CATEGORIA.setValue( param );
    }

    public void  setPostID_ARGOMENTO( double param ) {
        this.postID_ARGOMENTO.setValue( param );
    }

    public void  setPostID_ARGOMENTO( double param, Format ignore ) throws java.text.ParseException {
        this.postID_ARGOMENTO.setValue( param );
    }

    public void  setPostID_ARGOMENTO( Object param, Format format ) throws java.text.ParseException {
        this.postID_ARGOMENTO.setValue( param, format );
    }

    public void  setPostID_ARGOMENTO( Double param ) {
        this.postID_ARGOMENTO.setValue( param );
    }

    public void  setPostID_RILEVANZA( double param ) {
        this.postID_RILEVANZA.setValue( param );
    }

    public void  setPostID_RILEVANZA( double param, Format ignore ) throws java.text.ParseException {
        this.postID_RILEVANZA.setValue( param );
    }

    public void  setPostID_RILEVANZA( Object param, Format format ) throws java.text.ParseException {
        this.postID_RILEVANZA.setValue( param, format );
    }

    public void  setPostID_RILEVANZA( Double param ) {
        this.postID_RILEVANZA.setValue( param );
    }

    public void  setPostID_AREA( double param ) {
        this.postID_AREA.setValue( param );
    }

    public void  setPostID_AREA( double param, Format ignore ) throws java.text.ParseException {
        this.postID_AREA.setValue( param );
    }

    public void  setPostID_AREA( Object param, Format format ) throws java.text.ParseException {
        this.postID_AREA.setValue( param, format );
    }

    public void  setPostID_AREA( Double param ) {
        this.postID_AREA.setValue( param );
    }

    public void  setPostTITOLO( String param ) {
        this.postTITOLO.setValue( param );
    }

    public void  setPostTITOLO( Object param ) {
        this.postTITOLO.setValue( param );
    }

    public void  setPostTITOLO( Object param, Format ignore ) {
        this.postTITOLO.setValue( param );
    }

    public void  setPostTIPO_TESTO( String param ) {
        this.postTIPO_TESTO.setValue( param );
    }

    public void  setPostTIPO_TESTO( Object param ) {
        this.postTIPO_TESTO.setValue( param );
    }

    public void  setPostTIPO_TESTO( Object param, Format ignore ) {
        this.postTIPO_TESTO.setValue( param );
    }

    public void  setUrlTESTO( String param ) {
        this.urlTESTO.setValue( param );
    }

    public void  setUrlTESTO( Object param ) {
        this.urlTESTO.setValue( param );
    }

    public void  setUrlTESTO( Object param, Format ignore ) {
        this.urlTESTO.setValue( param );
    }

    public void  setCtrlABSTRACT( String param ) {
        this.ctrlABSTRACT.setValue( param );
    }

    public void  setCtrlABSTRACT( Object param ) {
        this.ctrlABSTRACT.setValue( param );
    }

    public void  setCtrlABSTRACT( Object param, Format ignore ) {
        this.ctrlABSTRACT.setValue( param );
    }

    public void  setCtrlLINK( String param ) {
        this.ctrlLINK.setValue( param );
    }

    public void  setCtrlLINK( Object param ) {
        this.ctrlLINK.setValue( param );
    }

    public void  setCtrlLINK( Object param, Format ignore ) {
        this.ctrlLINK.setValue( param );
    }

    public void  setPostIMMAGINE( String param ) {
        this.postIMMAGINE.setValue( param );
    }

    public void  setPostIMMAGINE( Object param ) {
        this.postIMMAGINE.setValue( param );
    }

    public void  setPostIMMAGINE( Object param, Format ignore ) {
        this.postIMMAGINE.setValue( param );
    }

    public void  setPostICONA( String param ) {
        this.postICONA.setValue( param );
    }

    public void  setPostICONA( Object param ) {
        this.postICONA.setValue( param );
    }

    public void  setPostICONA( Object param, Format ignore ) {
        this.postICONA.setValue( param );
    }

    public void  setPostDATA_RIFERIMENTO( Object param, Format format ) throws java.text.ParseException {
        this.postDATA_RIFERIMENTO.setValue( param, format );
    }

    public void  setPostDATA_RIFERIMENTO( Date param ) {
        this.postDATA_RIFERIMENTO.setValue( param );
    }

    public void  setPostINIZIO_PUBBLICAZIONE( Object param, Format format ) throws java.text.ParseException {
        this.postINIZIO_PUBBLICAZIONE.setValue( param, format );
    }

    public void  setPostINIZIO_PUBBLICAZIONE( Date param ) {
        this.postINIZIO_PUBBLICAZIONE.setValue( param );
    }

    public void  setPostFINE_PUBBLICAZIONE( Object param, Format format ) throws java.text.ParseException {
        this.postFINE_PUBBLICAZIONE.setValue( param, format );
    }

    public void  setPostFINE_PUBBLICAZIONE( Date param ) {
        this.postFINE_PUBBLICAZIONE.setValue( param );
    }

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setPostREVISIONE( double param ) {
        this.postREVISIONE.setValue( param );
    }

    public void  setPostREVISIONE( double param, Format ignore ) throws java.text.ParseException {
        this.postREVISIONE.setValue( param );
    }

    public void  setPostREVISIONE( Object param, Format format ) throws java.text.ParseException {
        this.postREVISIONE.setValue( param, format );
    }

    public void  setPostREVISIONE( Double param ) {
        this.postREVISIONE.setValue( param );
    }

    public void  setPostID_SEZIONE( double param ) {
        this.postID_SEZIONE.setValue( param );
    }

    public void  setPostID_SEZIONE( double param, Format ignore ) throws java.text.ParseException {
        this.postID_SEZIONE.setValue( param );
    }

    public void  setPostID_SEZIONE( Object param, Format format ) throws java.text.ParseException {
        this.postID_SEZIONE.setValue( param, format );
    }

    public void  setPostID_SEZIONE( Double param ) {
        this.postID_SEZIONE.setValue( param );
    }

    public void  setPostSEQUENZA( double param ) {
        this.postSEQUENZA.setValue( param );
    }

    public void  setPostSEQUENZA( double param, Format ignore ) throws java.text.ParseException {
        this.postSEQUENZA.setValue( param );
    }

    public void  setPostSEQUENZA( Object param, Format format ) throws java.text.ParseException {
        this.postSEQUENZA.setValue( param, format );
    }

    public void  setPostSEQUENZA( Double param ) {
        this.postSEQUENZA.setValue( param );
    }

    public void  setPostID_DOCUMENTO( double param ) {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setPostID_DOCUMENTO( double param, Format ignore ) throws java.text.ParseException {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setPostID_DOCUMENTO( Object param, Format format ) throws java.text.ParseException {
        this.postID_DOCUMENTO.setValue( param, format );
    }

    public void  setPostID_DOCUMENTO( Double param ) {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setCtrlICONA( String param ) {
        this.ctrlICONA.setValue( param );
    }

    public void  setCtrlICONA( Object param ) {
        this.ctrlICONA.setValue( param );
    }

    public void  setCtrlICONA( Object param, Format ignore ) {
        this.ctrlICONA.setValue( param );
    }

    public void  setPostALLEGATO( long param ) {
        this.postALLEGATO.setValue( param );
    }

    public void  setPostALLEGATO( long param, Format ignore ) throws java.text.ParseException {
        this.postALLEGATO.setValue( param );
    }

    public void  setPostALLEGATO( Object param, Format format ) throws java.text.ParseException {
        this.postALLEGATO.setValue( param, format );
    }

    public void  setPostALLEGATO( Long param ) {
        this.postALLEGATO.setValue( param );
    }

    public void  setPostSTATO( String param ) {
        this.postSTATO.setValue( param );
    }

    public void  setPostSTATO( Object param ) {
        this.postSTATO.setValue( param );
    }

    public void  setPostSTATO( Object param, Format ignore ) {
        this.postSTATO.setValue( param );
    }

    public void  setUrlID( double param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( double param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Double param ) {
        this.urlID.setValue( param );
    }

    public void  setPostLINK( String param ) {
        this.postLINK.setValue( param );
    }

    public void  setPostLINK( Object param ) {
        this.postLINK.setValue( param );
    }

    public void  setPostLINK( Object param, Format ignore ) {
        this.postLINK.setValue( param );
    }

    public void  setUrlREV( long param ) {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( long param, Format ignore ) throws java.text.ParseException {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( Object param, Format format ) throws java.text.ParseException {
        this.urlREV.setValue( param, format );
    }

    public void  setUrlREV( Long param ) {
        this.urlREV.setValue( param );
    }

    public AMV_DOCUMENTIRow getRow() {
        return row;
    }

    public void setRow( AMV_DOCUMENTIRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @5-0D11223E
    public AMV_DOCUMENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-1FBD4C68
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT d.ID_DOCUMENTO "
                    + ", d.REVISIONE "
                    + ", r.cronologia "
                    + ", r.note "
                    + ", STATO "
                    + ",  "
                    + "ID_TIPOLOGIA "
                    + ", ID_CATEGORIA "
                    + ", ID_ARGOMENTO "
                    + ", ID_RILEVANZA "
                    + ", ID_SEZIONE "
                    + ", SEQUENZA "
                    + ",  "
                    + "nvl({ID_AREA}, ID_AREA) ID_AREA "
                    + ", nvl({ID_AREA}, ID_AREA) ID_AREA_SEL "
                    + ",  "
                    + "nvl('{TITOLO}',TITOLO) TITOLO "
                    + ", nvl('{TIPO_TESTO}',TIPO_TESTO) TIPO_TESTO "
                    + ", TESTO "
                    + ", XML "
                    + ",  "
                    + "ABSTRACT "
                    + ", nvl('{LINK}',LINK) LINK "
                    + ", decode (TIPO_TESTO, 'Link', nvl('{LINK}',LINK),  "
                    + "'') LINKURL "
                    + ", decode (TIPO_TESTO, 'Testo', nvl('{LINK}',LINK), '') LINKFILE "
                    + ",  "
                    + "decode (TIPO_TESTO, 'Form', amv_documento.get_modello(nvl('{LINK}',LINK),'R'),  "
                    + "'') LINKMR "
                    + ", decode (TIPO_TESTO, 'Form',  "
                    + "amv_documento.get_modello(nvl('{LINK}',LINK),'A'), '') LINKMA "
                    + ", decode (TIPO_TESTO, 'Form',  "
                    + "AFC.get_stringParm(nvl('{LINK}',LINK),'iter'), '') LINK_ITER "
                    + ", decode (TIPO_TESTO, 'Form',  "
                    + "AFC.get_stringParm(nvl('{LINK}',LINK),'inoltro'), '') LINK_INOLTRO "
                    + ",  "
                    + "decode(instr(link,'<and>cr='),0,'',substr(link,instr(link,'<and>cr=')+5)) cr "
                    + ", decode (TIPO_TESTO, 'Xquery',  "
                    + "nvl('{LINK}',LINK),'SQLquery',nvl('{LINK}',LINK), '') LINKDATASOURCE "
                    + ",  "
                    + "DATA_RIFERIMENTO "
                    + ", INIZIO_PUBBLICAZIONE "
                    + ", FINE_PUBBLICAZIONE "
                    + ",  "
                    + "nvl(NOME_AUTORE,'{Utente}') NOME_AUTORE, DATA_INSERIMENTO, NOME_UTENTE,  "
                    + "DATA_ULTIMA_MODIFICA DATA_AGGIORNAMENTO "
                    + ", amv_revisione.get_img_stato(STATO) STATO_DOCUMENTO "
                    + ",  "
                    + "amv_revisione.get_flusso('{Utente}', d.ID_DOCUMENTO, d.REVISIONE, d.stato,'T') FLUSSO "
                    + ",  "
                    + "amv_documento.get_allegati(d.id_documento, d.revisione) ALLEGATI "
                    + ", IMMAGINE "
                    + ",  "
                    + "ICONA "
                    + "FROM AMV_VISTA_DOCUMENTI d,  "
                    + "AMV_DOCUMENTI_REVISIONI r "
                    + "WHERE d.ID_DOCUMENTO = {ID} "
                    + "  AND d.REVISIONE = {REV} "
                    + "  AND amv_revisione.get_diritto_modifica('{Utente}',  "
                    + "d.ID_DOCUMENTO,  "
                    + "d.REVISIONE) = 1 "
                    + "  AND r.ID_DOCUMENTO = d.ID_DOCUMENTO "
                    + "  AND r.REVISIONE  = d.REVISIONE  "
                    + "  AND d.tipo_testo != 'Richiesta'" );
        if ( urlID.getObjectValue() == null ) urlID.setValue( 0 );
        command.addParameter( "ID", urlID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( postID_AREA.getObjectValue() == null ) postID_AREA.setValue( null );
        command.addParameter( "ID_AREA", postID_AREA, null );
        if ( StringUtils.isEmpty( (String) postTITOLO.getObjectValue() ) ) postTITOLO.setValue( "" );
        command.addParameter( "TITOLO", postTITOLO, null );
        if ( StringUtils.isEmpty( (String) postLINK.getObjectValue() ) ) postLINK.setValue( "" );
        command.addParameter( "LINK", postLINK, null );
        if ( StringUtils.isEmpty( (String) postTIPO_TESTO.getObjectValue() ) ) postTIPO_TESTO.setValue( "" );
        command.addParameter( "TIPO_TESTO", postTIPO_TESTO, null );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( 0 );
        command.addParameter( "REV", urlREV, null );
        if ( ! command.isSetAllParams() ) {
            empty = true;
            ds.closeConnection();
            return true;
        }
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        DbRow record = null;
        if ( ! ds.hasErrors() ) {
            record = command.getOneRow();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @5-892327B3
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setID_DOCUMENTO(Utils.convertToLong(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
            row.setREVISIONE(Utils.convertToLong(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
            row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
            row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
            row.setREVISIONE_LABEL(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVISIONE_LABELField())));
            row.setSTATO_DOCUMENTO(Utils.convertToString(ds.parse(record.get("STATO_DOCUMENTO"), row.getSTATO_DOCUMENTOField())));
            row.setFLUSSO(Utils.convertToString(ds.parse(record.get("FLUSSO"), row.getFLUSSOField())));
            try {
                row.setDATA_INSERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_INSERIMENTO"), row.getDATA_INSERIMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setAUTORE(Utils.convertToString(ds.parse(record.get("NOME_AUTORE"), row.getAUTOREField())));
            try {
                row.setDATA_AGGIORNAMENTO(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_AGGIORNAMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setUTENTE_AGGIORNAMENTO(Utils.convertToString(ds.parse(record.get("NOME_UTENTE"), row.getUTENTE_AGGIORNAMENTOField())));
            row.setCRONOLOGIA(Utils.convertToString(ds.parse(record.get("CRONOLOGIA"), row.getCRONOLOGIAField())));
            row.setNOTE(Utils.convertToString(ds.parse(record.get("NOTE"), row.getNOTEField())));
            row.setID_AREA(Utils.convertToLong(ds.parse(record.get("ID_AREA"), row.getID_AREAField())));
            row.setID_AREA_SEL(Utils.convertToString(ds.parse(record.get("ID_AREA_SEL"), row.getID_AREA_SELField())));
            row.setID_TIPOLOGIA(Utils.convertToLong(ds.parse(record.get("ID_TIPOLOGIA"), row.getID_TIPOLOGIAField())));
            row.setID_CATEGORIA(Utils.convertToLong(ds.parse(record.get("ID_CATEGORIA"), row.getID_CATEGORIAField())));
            row.setID_ARGOMENTO(Utils.convertToLong(ds.parse(record.get("ID_ARGOMENTO"), row.getID_ARGOMENTOField())));
            row.setID_SEZIONE(Utils.convertToLong(ds.parse(record.get("ID_SEZIONE"), row.getID_SEZIONEField())));
            row.setID_RILEVANZA(Utils.convertToLong(ds.parse(record.get("ID_RILEVANZA"), row.getID_RILEVANZAField())));
            row.setSEQUENZA(Utils.convertToLong(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
            try {
                row.setDATA_RIFERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_RIFERIMENTO"), row.getDATA_RIFERIMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setINIZIO_PUBBLICAZIONE(Utils.convertToDate(ds.parse(record.get("INIZIO_PUBBLICAZIONE"), row.getINIZIO_PUBBLICAZIONEField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setFINE_PUBBLICAZIONE(Utils.convertToDate(ds.parse(record.get("FINE_PUBBLICAZIONE"), row.getFINE_PUBBLICAZIONEField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setTIPO_TESTO(Utils.convertToString(ds.parse(record.get("TIPO_TESTO"), row.getTIPO_TESTOField())));
            row.setTESTO(Utils.convertToString(ds.parse(record.get("TESTO"), row.getTESTOField())));
            row.setTESTOXQUERY(Utils.convertToString(ds.parse(record.get("TESTO"), row.getTESTOXQUERYField())));
            row.setLINKURL(Utils.convertToString(ds.parse(record.get("LINKURL"), row.getLINKURLField())));
            row.setCR(Utils.convertToString(ds.parse(record.get("CR"), row.getCRField())));
            row.setXML(Utils.convertToString(ds.parse(record.get("XML"), row.getXMLField())));
            row.setABSTRACT(Utils.convertToString(ds.parse(record.get("ABSTRACT"), row.getABSTRACTField())));
            row.setLINKMR(Utils.convertToString(ds.parse(record.get("LINKMR"), row.getLINKMRField())));
            row.setLINKMA(Utils.convertToString(ds.parse(record.get("LINKMA"), row.getLINKMAField())));
            row.setLINK_ITER(Utils.convertToString(ds.parse(record.get("LINK_ITER"), row.getLINK_ITERField())));
            row.setLINK_INOLTRO(Utils.convertToString(ds.parse(record.get("LINK_INOLTRO"), row.getLINK_INOLTROField())));
            row.setLINKDATASOURCE(Utils.convertToString(ds.parse(record.get("LINKDATASOURCE"), row.getLINKDATASOURCEField())));
            row.setIMMAGINE(Utils.convertToString(ds.parse(record.get("IMMAGINE"), row.getIMMAGINEField())));
            row.setICONA(Utils.convertToString(ds.parse(record.get("ICONA"), row.getICONAField())));
            row.setALLEGATI(Utils.convertToString(ds.parse(record.get("ALLEGATI"), row.getALLEGATIField())));
        }
//End loadDataBind

//End of load @5-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//insert @5-55846930
        Collection insert() {	//custom AFC
        //boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_DOCUMENTO.INSERISCI ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", urlP_ID_DOCUMENTO, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_OUTPUT_PARAMETER );
            command.addParameter( "P_ID_TIPOLOGIA", postID_TIPOLOGIA, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_CATEGORIA", postID_CATEGORIA, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_ARGOMENTO", postID_ARGOMENTO, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_RILEVANZA", postID_RILEVANZA, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_AREA", postID_AREA, java.sql.Types.NUMERIC, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postTITOLO.getObjectValue() ) ) postTITOLO.setValue( "" );
            command.addParameter( "P_TITOLO", postTITOLO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postTIPO_TESTO.getObjectValue() ) ) postTIPO_TESTO.setValue( "" );
            command.addParameter( "P_TIPO_TESTO", postTIPO_TESTO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlTESTO.getObjectValue() ) ) urlTESTO.setValue( "" );
            command.addParameter( "P_TESTO", urlTESTO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getABSTRACT()) ) row.setABSTRACT( "" );
            command.addParameter( "P_ABSTRACT", row.getABSTRACTField(), java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getLINK()) ) row.setLINK( "" );
            command.addParameter( "P_LINK", row.getLINKField(), java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postIMMAGINE.getObjectValue() ) ) postIMMAGINE.setValue( "" );
            command.addParameter( "P_IMMAGINE", postIMMAGINE, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postICONA.getObjectValue() ) ) postICONA.setValue( "" );
            command.addParameter( "P_ICONA", postICONA, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_DATA_RIFERIMENTO", postDATA_RIFERIMENTO, java.sql.Types.DATE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_INIZIO_PUBBLICAZIONE", postINIZIO_PUBBLICAZIONE, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_FINE_PUBBLICAZIONE", postFINE_PUBBLICAZIONE, java.sql.Types.DATE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_AUTORE", sesUtente, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_SEZIONE", postID_SEZIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_SEQUENZA", postSEQUENZA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert
            Collection cParam = null;	//custom AFC
//insertDataBound @5-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
				cParam = command.getParameters();  //custom AFC 
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @5-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            //return ( ! isErrors );
			return cParam;		//custom AFC 
        }
//End End of insert

//update @5-92BC0ADC
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_DOCUMENTO.AGGIORNA ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", postID_DOCUMENTO, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_TIPOLOGIA", postID_TIPOLOGIA, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_CATEGORIA", postID_CATEGORIA, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_ARGOMENTO", postID_ARGOMENTO, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_RILEVANZA", postID_RILEVANZA, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_AREA", postID_AREA, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postTITOLO.getObjectValue() ) ) postTITOLO.setValue( "" );
            command.addParameter( "P_TITOLO", postTITOLO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postTIPO_TESTO.getObjectValue() ) ) postTIPO_TESTO.setValue( "" );
            command.addParameter( "P_TIPO_TESTO", postTIPO_TESTO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlTESTO.getObjectValue() ) ) urlTESTO.setValue( "" );
            command.addParameter( "P_TESTO", urlTESTO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getABSTRACT()) ) row.setABSTRACT( "" );
            command.addParameter( "P_ABSTRACT", row.getABSTRACTField(), java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getLINK()) ) row.setLINK( "" );
            command.addParameter( "P_LINK", row.getLINKField(), java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postIMMAGINE.getObjectValue() ) ) postIMMAGINE.setValue( "" );
            command.addParameter( "P_IMMAGINE", postIMMAGINE, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getICONA()) ) row.setICONA( "" );
            command.addParameter( "P_ICONA", row.getICONAField(), java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_BLOB", postALLEGATO, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_DATA_RIFERIMENTO", postDATA_RIFERIMENTO, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_INIZIO_PUBBLICAZIONE", postINIZIO_PUBBLICAZIONE, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_FINE_PUBBLICAZIONE", postFINE_PUBBLICAZIONE, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE_AGGIORNAMENTO", sesUtente, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_ID_SEZIONE", postID_SEZIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_SEQUENZA", postSEQUENZA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @5-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @5-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//delete @5-BCD48EDC
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_DOCUMENTO.ELIMINA ( ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", postID_DOCUMENTO, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.INTEGER, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postSTATO.getObjectValue() ) ) postSTATO.setValue( "" );
            command.addParameter( "P_STATO", postSTATO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE_AGGIORNAMENTO", sesUtente, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );


//End delete

//deleteDataBound @5-67425D5E
            fireBeforeExecuteDeleteEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteDeleteEvent( new DataObjectEvent(command) );

//End deleteDataBound

//End of delete @5-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @5-AD9D9279
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "P_ID_DOCUMENTO".equals(name) && "url".equals(prefix) ) {
                param = urlP_ID_DOCUMENTO;
            } else if ( "P_ID_DOCUMENTO".equals(name) && prefix == null ) {
                param = urlP_ID_DOCUMENTO;
            }
            if ( "ID_TIPOLOGIA".equals(name) && "post".equals(prefix) ) {
                param = postID_TIPOLOGIA;
            } else if ( "ID_TIPOLOGIA".equals(name) && prefix == null ) {
                param = postID_TIPOLOGIA;
            }
            if ( "ID_CATEGORIA".equals(name) && "post".equals(prefix) ) {
                param = postID_CATEGORIA;
            } else if ( "ID_CATEGORIA".equals(name) && prefix == null ) {
                param = postID_CATEGORIA;
            }
            if ( "ID_ARGOMENTO".equals(name) && "post".equals(prefix) ) {
                param = postID_ARGOMENTO;
            } else if ( "ID_ARGOMENTO".equals(name) && prefix == null ) {
                param = postID_ARGOMENTO;
            }
            if ( "ID_RILEVANZA".equals(name) && "post".equals(prefix) ) {
                param = postID_RILEVANZA;
            } else if ( "ID_RILEVANZA".equals(name) && prefix == null ) {
                param = postID_RILEVANZA;
            }
            if ( "ID_AREA".equals(name) && "post".equals(prefix) ) {
                param = postID_AREA;
            } else if ( "ID_AREA".equals(name) && prefix == null ) {
                param = postID_AREA;
            }
            if ( "TITOLO".equals(name) && "post".equals(prefix) ) {
                param = postTITOLO;
            } else if ( "TITOLO".equals(name) && prefix == null ) {
                param = postTITOLO;
            }
            if ( "TIPO_TESTO".equals(name) && "post".equals(prefix) ) {
                param = postTIPO_TESTO;
            } else if ( "TIPO_TESTO".equals(name) && prefix == null ) {
                param = postTIPO_TESTO;
            }
            if ( "TESTO".equals(name) && "url".equals(prefix) ) {
                param = urlTESTO;
            } else if ( "TESTO".equals(name) && prefix == null ) {
                param = urlTESTO;
            }
            if ( "ABSTRACT".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlABSTRACT;
            } else if ( "ABSTRACT".equals(name) && prefix == null ) {
                param = ctrlABSTRACT;
            }
            if ( "LINK".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlLINK;
            } else if ( "LINK".equals(name) && prefix == null ) {
                param = ctrlLINK;
            }
            if ( "IMMAGINE".equals(name) && "post".equals(prefix) ) {
                param = postIMMAGINE;
            } else if ( "IMMAGINE".equals(name) && prefix == null ) {
                param = postIMMAGINE;
            }
            if ( "ICONA".equals(name) && "post".equals(prefix) ) {
                param = postICONA;
            } else if ( "ICONA".equals(name) && prefix == null ) {
                param = postICONA;
            }
            if ( "DATA_RIFERIMENTO".equals(name) && "post".equals(prefix) ) {
                param = postDATA_RIFERIMENTO;
            } else if ( "DATA_RIFERIMENTO".equals(name) && prefix == null ) {
                param = postDATA_RIFERIMENTO;
            }
            if ( "INIZIO_PUBBLICAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postINIZIO_PUBBLICAZIONE;
            } else if ( "INIZIO_PUBBLICAZIONE".equals(name) && prefix == null ) {
                param = postINIZIO_PUBBLICAZIONE;
            }
            if ( "FINE_PUBBLICAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postFINE_PUBBLICAZIONE;
            } else if ( "FINE_PUBBLICAZIONE".equals(name) && prefix == null ) {
                param = postFINE_PUBBLICAZIONE;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "REVISIONE".equals(name) && "post".equals(prefix) ) {
                param = postREVISIONE;
            } else if ( "REVISIONE".equals(name) && prefix == null ) {
                param = postREVISIONE;
            }
            if ( "ID_SEZIONE".equals(name) && "post".equals(prefix) ) {
                param = postID_SEZIONE;
            } else if ( "ID_SEZIONE".equals(name) && prefix == null ) {
                param = postID_SEZIONE;
            }
            if ( "SEQUENZA".equals(name) && "post".equals(prefix) ) {
                param = postSEQUENZA;
            } else if ( "SEQUENZA".equals(name) && prefix == null ) {
                param = postSEQUENZA;
            }
            if ( "ID_DOCUMENTO".equals(name) && "post".equals(prefix) ) {
                param = postID_DOCUMENTO;
            } else if ( "ID_DOCUMENTO".equals(name) && prefix == null ) {
                param = postID_DOCUMENTO;
            }
            if ( "ICONA".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlICONA;
            } else if ( "ICONA".equals(name) && prefix == null ) {
                param = ctrlICONA;
            }
            if ( "ALLEGATO".equals(name) && "post".equals(prefix) ) {
                param = postALLEGATO;
            } else if ( "ALLEGATO".equals(name) && prefix == null ) {
                param = postALLEGATO;
            }
            if ( "STATO".equals(name) && "post".equals(prefix) ) {
                param = postSTATO;
            } else if ( "STATO".equals(name) && prefix == null ) {
                param = postSTATO;
            }
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "LINK".equals(name) && "post".equals(prefix) ) {
                param = postLINK;
            } else if ( "LINK".equals(name) && prefix == null ) {
                param = postLINK;
            }
            if ( "REV".equals(name) && "url".equals(prefix) ) {
                param = urlREV;
            } else if ( "REV".equals(name) && prefix == null ) {
                param = urlREV;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @5-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @5-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @5-305A023C
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @5-D00ACF95
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @5-3BAD39CE
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildInsertEvent @5-FBA08B71
    public void fireBeforeBuildInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
//End fireBeforeBuildInsertEvent

//fireBeforeExecuteInsertEvent @5-47AFA6A5
    public void fireBeforeExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
//End fireBeforeExecuteInsertEvent

//fireAfterExecuteInsertEvent @5-E9CE95AE
    public void fireAfterExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//End fireAfterExecuteInsertEvent

//fireBeforeBuildSelectEvent @5-2405BE8B
    public void fireBeforeBuildUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @5-E9DFF86B
    public void fireBeforeExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @5-580A2987
    public void fireAfterExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildSelectEvent @5-D021D0EA
    public void fireBeforeBuildDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteDeleteEvent @5-DD540FBB
    public void fireBeforeExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
//End fireBeforeExecuteDeleteEvent

//fireAfterExecuteDeleteEvent @5-2A6E2049
    public void fireAfterExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
//End fireAfterExecuteDeleteEvent

//class DataObject Tail @5-ED3F53A4
} // End of class DS
//End class DataObject Tail

