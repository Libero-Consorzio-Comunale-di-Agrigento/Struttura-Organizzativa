//AMV_DOCUMENTIHandler Head @5-9190F3C7
package amvadm.AdmDocumento;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import java.io.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import it.finmatica.jfc.io.*;
import it.finmatica.jfc.dbUtil.*;
import oracle.sql.CLOB;
import java.nio.charset.Charset;

public class AMV_DOCUMENTIRecordHandler implements RecordListener {
//End AMV_DOCUMENTIHandler Head

//BeforeShow Head @5-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//Set values @5-E6411AF0
        if (! e.getRecord().isEditMode()) {
            e.getRecord().getControl("REVISIONE").setDefaultValue(0);
            e.getRecord().getControl("STATO").setDefaultValue(0);
            e.getRecord().getControl("DATA_INSERIMENTO").setDefaultValue(java.util.Calendar.getInstance().getTime());
            e.getRecord().getControl("AUTORE").setDefaultValue(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("UserLogin"));
            e.getRecord().getControl("DATA_AGGIORNAMENTO").setDefaultValue(java.util.Calendar.getInstance().getTime());
            e.getRecord().getControl("UTENTE_AGGIORNAMENTO").setDefaultValue(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("UserLogin"));
            e.getRecord().getControl("ID_TIPOLOGIA").setDefaultValue(0);
            e.getRecord().getControl("ID_RILEVANZA").setDefaultValue(3);
            e.getRecord().getControl("DATA_RIFERIMENTO").setDefaultValue(java.util.Calendar.getInstance().getTime());
            e.getRecord().getControl("TIPO_TESTO").setDefaultValue("Testo");
            e.getRecord().getControl("LINK_ITER").setDefaultValue("V");
            e.getRecord().getControl("LINK_INOLTRO").setDefaultValue("I");
        }
//End Set values

//Event BeforeShow Action Custom Code @143-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
 if (e.getRecord().isEditMode()) {
 	e.getRecord().getControl("RECORD_TITLE").setValue("Aggiornamento Documento");
	e.getRecord().getControl("FILE_UPLOAD").setValue("<input size=\"90\" class=\"AFCInput\" type=\"file\" name=\"FILE_UPLOAD\"");
 } else {
 	e.getRecord().getControl("RECORD_TITLE").setValue("Nuovo Documento");
	e.getRecord().getControl("FILE_UPLOAD").setValue("Inserimento allegati solo in aggiornamento");
 }
//End Event BeforeShow Action Custom Code

//BeforeShow Tail @5-FCB6E20C
    }
//End BeforeShow Tail

//OnValidate Head @5-5F430F8E
    public void onValidate(Event e) {
//End OnValidate Head

//Event OnValidate Action Custom Code @156-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

  if (e.getPage().getFile("FILE_UPLOAD") != null) {
       if (e.getPage().getFile("FILE_UPLOAD").getSize() == 0)
       e.getRecord().addError("File Allegato vuoto o inesistente");
  }
  if (e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("Form")) {
      String linkmr = "";
	  String linkma = "";
	  String link_iter = "";
	  String link_inoltro = "";
	  if (e.getRecord().getControl("LINKMR").getValue() != null) {
	      linkmr = e.getRecord().getControl("LINKMR").getValue().toString();
	  }
	  if (e.getRecord().getControl("LINKMA").getValue() != null) {
	      linkma = e.getRecord().getControl("LINKMA").getValue().toString();
	  }
	  if (e.getRecord().getControl("LINK_ITER").getValue() != null) {
	      link_iter = " iter="+e.getRecord().getControl("LINK_ITER").getValue().toString();
	  }
	  if (e.getRecord().getControl("LINK_INOLTRO").getValue() != null) {
	      link_inoltro = " inoltro="+e.getRecord().getControl("LINK_INOLTRO").getValue().toString();
	  }
	  e.getRecord().getControl("LINK").setValue(linkmr+"|"+linkma+"|"+link_iter+link_inoltro);
  } 
/*  if (e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("Testo")) {
      e.getRecord().getControl("LINK").setValue(e.getRecord().getControl("LINKFILE").getValue());
  } */
  if (e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("Link")) {
      e.getRecord().getControl("LINK").setValue(e.getRecord().getControl("LINKURL").getValue());
  } 
  if (e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("Xquery")||e.getRecord().getControl("TIPO_TESTO").getValue().toString().equals("SQLquery")) {
      e.getRecord().getControl("LINK").setValue(e.getRecord().getControl("LINKDATASOURCE").getValue());
      e.getRecord().getControl("TESTO").setValue(e.getRecord().getControl("TESTOXQUERY").getValue());
  } 

//End Event OnValidate Action Custom Code

//OnValidate Tail @5-FCB6E20C
    }
//End OnValidate Tail

//BeforeSelect Head @5-E5EC9AD3
    public void beforeSelect(Event e) {
//End BeforeSelect Head

//BeforeSelect Tail @5-FCB6E20C
    }
//End BeforeSelect Tail

//BeforeInsert Head @5-75B62B83
    public void beforeInsert(Event e) {
//End BeforeInsert Head

//BeforeInsert Tail @5-FCB6E20C
    }
//End BeforeInsert Tail

//AfterInsert Head @5-767A9165
    public void afterInsert(Event e) {
//End AfterInsert Head

//Event AfterInsert Action Custom Code @172-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

try {
 // Inizializzo connessione
	Properties siteProps = new Properties();
	siteProps = (Properties)ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
	String connName = siteProps.getProperty("cn.url");
	connName = connName.substring(connName.indexOf("jdbc"));
	String charEncoding = (new CCSLocale()).getCharacterEncoding();

	Context initContext = new InitialContext();
	Context envContext = (Context)initContext.lookup("java:comp/env/");

	DataSource ds = (DataSource)envContext.lookup(connName);
	Connection con = ds.getConnection(); 
	String whereClause;
	Integer idBlob;
	Integer idDocumento;
	Integer idRevisione;

	PreparedStatement ps = null;
    ResultSet rs = null;

	//Inserimento testo nel CLOB
	if (e.getRecord().getControl("TESTO").getValue()!= null) {
		if (StringUtils.isEmpty(Utils.convertToString(e.getPage().getRequest().getAttribute("ID_DOCUMENTO")))) {
			e.getPage().getRequest().setAttribute("ID_DOCUMENTO",e.getPage().getHttpPostParameter("ID_DOCUMENTO"));
		}
		con.setAutoCommit(false);
		Statement stmt = con.createStatement();
		idDocumento = new Integer(e.getPage().getRequest().getAttribute("ID_DOCUMENTO").toString());	
		idRevisione = new Integer(e.getPage().getHttpPostParameter("REVISIONE"));
		whereClause = "where id_documento = " + idDocumento + " and revisione = " + idRevisione;
		String testo = Utils.convertToString(e.getRecord().getControl("TESTO").getValue());
/* Pulizia stringa da caratteri non riconoscibili di MS Word */
/*		String testo_ok = StringUtils.toHtml(testo); //.replaceAll("ì", "&igrave;");		

/* Scrittura CLOB via statement */
		rs = stmt.executeQuery("SELECT testo from amv_documenti " + whereClause);
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnType = rsmd.getColumnType(1);
		rs.close();

		stmt.executeUpdate("UPDATE amv_documenti set testo = empty_clob() " + whereClause);

		rs = stmt.executeQuery("SELECT testo FROM amv_documenti " + whereClause + " FOR UPDATE");
        
		if (rs.next()) {
			oracle.sql.CLOB c = (oracle.sql.CLOB) rs.getClob(1);
			Writer w = c.getCharacterOutputStream(0);      
			w.write(testo);
			w.flush();      
			rs.close();
			stmt.close();
		}
		con.commit();

/* fine scrittura CLOB via statement */
		con.setAutoCommit(true);
	}

// Inserimento allegato

	if (e.getPage().getFile("FILE_UPLOAD") != null) {
		byte[] b = e.getPage().getFile("FILE_UPLOAD").getContent();
		ByteArrayInputStream bais = new ByteArrayInputStream(b);
		String nomeFile =  e.getPage().getFile("FILE_UPLOAD").getName();
		String tipoFile = nomeFile.substring(nomeFile.lastIndexOf(".")+1);


				con.setAutoCommit(false);
		        ps = con.prepareStatement("select amv_blob_seq.nextval from dual"); 
                rs = ps.executeQuery();
                rs.next();
                idBlob = new Integer(rs.getString(1));
				whereClause = "where id_blob = " + idBlob.intValue();
                rs.close();
                ps.close();

		        ps = con.prepareStatement("insert into AMV_BLOB  values (?, ?, ?, empty_blob())");
                ps.setInt(1, idBlob.intValue());
                ps.setString(2, nomeFile);
			    ps.setString(3, tipoFile);
                ps.execute();
                ps.close();

		        idDocumento = new Integer(e.getPage().getHttpPostParameter("ID_DOCUMENTO"));
		        idRevisione = new Integer(e.getPage().getHttpPostParameter("REVISIONE"));
		        ps = con.prepareStatement("insert into AMV_DOCUMENTI_BLOB  values (?, ?, ?)");
                ps.setInt(1, idDocumento.intValue());
                ps.setInt(2, idRevisione.intValue());
                ps.setInt(3, idBlob.intValue());
                ps.execute();
                ps.close(); 
				
				LetturaScritturaFileDB writer = new LetturaScritturaFileDB(con,"AMV_BLOB","BLOB_FILE",whereClause);
				writer.scriviFile(bais);
				con.setAutoCommit(true);


			
 
	}
	con.close();
	} catch (Exception exc) {
//                 con.close();
		exc.printStackTrace();
		System.out.println("Eccez. in scrittura file");
	}

//End Event AfterInsert Action Custom Code

//AfterInsert Tail @5-FCB6E20C
    }
//End AfterInsert Tail

//BeforeUpdate Head @5-33A3CFAC
    public void beforeUpdate(Event e) {
//End BeforeUpdate Head

//BeforeUpdate Tail @5-FCB6E20C
    }
//End BeforeUpdate Tail

//AfterUpdate Head @5-306F754A
    public void afterUpdate(Event e) {
//End AfterUpdate Head

//Event AfterUpdate Action Custom Code @146-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */
// Inizializzo connessione
try {
	Properties siteProps = new Properties();
	siteProps = (Properties)ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
	String connName = siteProps.getProperty("cn.url");
	connName = connName.substring(connName.indexOf("jdbc"));
	String charEncoding = (new CCSLocale()).getCharacterEncoding();

	Context initContext = new InitialContext();
	Context envContext = (Context)initContext.lookup("java:comp/env/");

	DataSource ds = (DataSource)envContext.lookup(connName);
	Connection con = ds.getConnection(); 
	String whereClause;
	Integer idBlob;
	Integer idDocumento;
	Integer idRevisione;

	PreparedStatement ps = null;
    ResultSet rs = null;

	//Inserimento testo nel CLOB
	if (e.getRecord().getControl("TESTO").getValue()!= null) {
		if (!(e.getPage().getRequest().getAttribute("ID_DOCUMENTO") != null)) {
			e.getPage().getRequest().setAttribute("ID_DOCUMENTO",e.getPage().getHttpPostParameter("ID_DOCUMENTO"));
		}
		con.setAutoCommit(false);
		Statement stmt = con.createStatement();
		idDocumento = new Integer(e.getPage().getRequest().getAttribute("ID_DOCUMENTO").toString());	
		idRevisione = new Integer(e.getPage().getHttpPostParameter("REVISIONE"));
		whereClause = "where id_documento = " + idDocumento + " and revisione = " + idRevisione;
		String testo = Utils.convertToString(e.getRecord().getControl("TESTO").getValue());
		//String testo = testo.replaceAll("", "");		
/*		ByteArrayInputStream textBais = new ByteArrayInputStream(testo_ok.getBytes("8859_1"));
		LetturaScritturaFileDB textWriter = new LetturaScritturaFileDB(con,"AMV_DOCUMENTI","TESTO",whereClause);
		textWriter.scriviFile(textBais);*/
/* Scrittura CLOB via statement */
		rs = stmt.executeQuery("SELECT testo from amv_documenti " + whereClause);
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnType = rsmd.getColumnType(1);
		rs.close();

		stmt.executeUpdate("UPDATE amv_documenti set testo = empty_clob() " + whereClause);

		rs = stmt.executeQuery("SELECT testo FROM amv_documenti " + whereClause + " FOR UPDATE");
        
		if (rs.next()) {
			oracle.sql.CLOB c = (oracle.sql.CLOB) rs.getClob(1);
			Writer w = c.getCharacterOutputStream(0);      
			w.write(testo);
			w.flush();      
			rs.close();
			stmt.close();
		}
		con.commit();

/* fine scrittura CLOB via statement */
		con.setAutoCommit(true);
	}

	if (e.getPage().getFile("FILE_UPLOAD") != null) {
		byte[] b = e.getPage().getFile("FILE_UPLOAD").getContent();
		ByteArrayInputStream bais = new ByteArrayInputStream(b);
		String nomeFile =  e.getPage().getFile("FILE_UPLOAD").getName();
		String tipoFile = nomeFile.substring(nomeFile.lastIndexOf(".")+1);


				con.setAutoCommit(false);
		        ps = con.prepareStatement("select amv_blob_seq.nextval from dual"); 
                rs = ps.executeQuery();
                rs.next();
                idBlob = new Integer(rs.getString(1));
				whereClause = "where id_blob = " + idBlob.intValue();
                rs.close();
                ps.close();

		        ps = con.prepareStatement("insert into AMV_BLOB  values (?, ?, ?, empty_blob())");
                ps.setInt(1, idBlob.intValue());
                ps.setString(2, nomeFile);
			    ps.setString(3, tipoFile);
                ps.execute();
                ps.close();

		        idDocumento = new Integer(e.getPage().getHttpPostParameter("ID_DOCUMENTO"));
		        idRevisione = new Integer(e.getPage().getHttpPostParameter("REVISIONE"));
		        ps = con.prepareStatement("insert into AMV_DOCUMENTI_BLOB  values (?, ?, ?)");
                ps.setInt(1, idDocumento.intValue());
                ps.setInt(2, idRevisione.intValue());
                ps.setInt(3, idBlob.intValue());
                ps.execute();
                ps.close(); 
				
				LetturaScritturaFileDB writer = new LetturaScritturaFileDB(con,"AMV_BLOB","BLOB_FILE",whereClause);
				writer.scriviFile(bais);
				con.setAutoCommit(true);


			
 
	}
	con.close();
	} catch (Exception exc) {
//                 con.close();
		exc.printStackTrace();
		System.out.println("Eccez. in scrittura file");
	}

		
//End Event AfterUpdate Action Custom Code

//AfterUpdate Tail @5-FCB6E20C
    }
//End AfterUpdate Tail

//BeforeDelete Head @5-752E3118
    public void beforeDelete(Event e) {
//End BeforeDelete Head

//BeforeDelete Tail @5-FCB6E20C
    }
//End BeforeDelete Tail

//AfterDelete Head @5-76E28BFE
    public void afterDelete(Event e) {
//End AfterDelete Head

//AfterDelete Tail @5-FCB6E20C
    }
//End AfterDelete Tail

//AMV_DOCUMENTIHandler Tail @5-FCB6E20C
}
//End AMV_DOCUMENTIHandler Tail

