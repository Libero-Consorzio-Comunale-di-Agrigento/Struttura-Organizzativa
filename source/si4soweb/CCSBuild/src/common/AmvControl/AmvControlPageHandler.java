//AmvControlHandler imports @1-EC3ECFB8
package common.AmvControl;
import java.util.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
//End AmvControlHandler imports

//AmvControlHandler Head @1-5E3E0400
public class AmvControlPageHandler implements PageListener {
//End AmvControlHandler Head

//AfterInitialize Head @1-89E84600
    public void afterInitialize(Event e) {
//End AfterInitialize Head

//Event AfterInitialize Action Custom Code @2-44795B7A
String pagina_precedente = (String) SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC");
// Context corrente ("/nome progetto") in MVCONTEXT
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVCONTEXT", e.getPage().getRequest().getContextPath());
// Percorso corrente in MVPATH.
// per il percorso senza il nome di progetto andrebbe usato getServletPath() anzichè getRequestURI() 
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPATH", e.getPage().getRequest().getRequestURI());
// Percorso corrente completo di parametri in MVURL.
if (e.getPage().getRequest().getQueryString() != null) {
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVURL", e.getPage().getRequest().getRequestURI() + "?" + e.getPage().getRequest().getQueryString());
}
else
{
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVURL", e.getPage().getRequest().getRequestURI());
}
// Imposta la variabile MVRP (Return Page per navigazione trasversale tra progetti) con il valore
// del parametro di url MVRP che viene associato ad una voce in presenza di stringa "return=SI"
// nel campo note della voce.
if (e.getPage().getRequest().getParameter("MVRP")  != null) {
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVRP", e.getPage().getRequest().getParameter("MVRP").toString().replace('*','&'));
}
// Quando MVURL (url completo di parametri della pagina corrente) è uguale all'url della pagina chiamante
// l'operazione di ritorno è stata effettuata quindi la variabile MVRP viene pulita
if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVRP") != null) {
   if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVRP").toString().equals("../.." + SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVURL").toString())) { 
      SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVRP", "");
   }
}

// Controllo della abilitazione sulla pagina corrente
String accesso = "NO";
String current_page = e.getPage().getRequest().getServletPath();
current_page = "," + current_page;
String current_mvpg = null;
String voce_corrente = null;


if (e.getPage().getRequest().getParameter("MVPG")  != null) {
	current_mvpg = e.getPage().getRequest().getParameter("MVPG").toString();
}


// CONTROLLO VOCE CORRENTE IN BASE AL PERCORSO
// RICAVO VALORE DA ASSEGNARE A MVDIRUPLOAD
	Connection con = null;
	// Valori di default 
	String s1 = "GUEST";
	String s2 = "GUEST";
	String s3 = "AMV";
	String s4 = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVURL").toString();
	// Variabili istanziate dal filter
	if (SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente") != null) {
		s1 = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente").toString();
		s2 = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Ruolo").toString();
		s3 = SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Modulo").toString();
	} 

    try {  
		Properties siteProps = new Properties();
		siteProps = (Properties)ContextStorage.getInstance().getAttribute(Names.SITE_PROPERTIES_KEY);
		String connName = siteProps.getProperty("cn.url");
		connName = connName.substring(connName.indexOf("jdbc"));

		//Impostazione variabile di sessione MVDATASOURCE che identifica l'alias di connessione
        //utilizzato nella AmvAttachSelect per generare il parametro della UploadDownloadServlet
        SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVDATASOURCE", connName);


		Context initContext = new InitialContext();
		Context envContext = (Context)initContext.lookup("java:comp/env/");
		DataSource ds = (DataSource)envContext.lookup(connName);
		con = ds.getConnection();
		CallableStatement cstmt = con.prepareCall("{ ? = call AMV_MENU.GET_VOCE_PAGINA(?,?,?,?) }");
      	cstmt.setString(2,s1);
      	cstmt.setString(3,s2);
      	cstmt.setString(4,s3);
      	cstmt.setString(5,s4);
      	cstmt.registerOutParameter(1,Types.VARCHAR);
      	cstmt.execute();
      	voce_corrente = cstmt.getString(1);
      	cstmt.close();
		// Istanzio variabile MVDIRUPLOAD se è nulla
		if (!(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD") != null)) {
			CallableStatement cstmt1 = con.prepareCall("{ ? = call AMVWEB.GET_PREFERENZA(?,?) }");
			cstmt1.setString(2,"Directory Upload");
			cstmt1.setString(3,s3);
			cstmt1.registerOutParameter(1,Types.VARCHAR);
			cstmt1.execute();
			SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVDIRUPLOAD",cstmt1.getString(1));
			cstmt1.close();
    	}
	} catch (Exception exc) {
      System.out.println(exc.getMessage());
    } finally {
		try {
			con.close();
		} catch (Exception exc) {
      		System.out.println(exc.getMessage());
    	}	
	}
//FINE CONTROLLO VOCE CORRENTE

// Impostazione valore di default "common" di MVDIRUPLOAD se ancora nulla 
// (verrà usato in concatenazione al realpath)
if (!(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVDIRUPLOAD") != null)) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVDIRUPLOAD","common");
}

// VARIABILE DI SESSIONE MVWEBSITE
SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVWEBSITE",com.codecharge.util.ContextStorage.getContext().getInitParameter("webSite"));

// INIZIALIZZAZIONE ATTRIBUTO ACCESSO
 e.getPage().getRequest().setAttribute("ACCESSO", "NO");


if (e.getPage().getRequest().getParameter("MVPG")  != null) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPC", e.getPage().getRequest().getParameter("MVPG"));
}
else {
//  CCS 2.2 .3
	//SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPC", e.getPage().getName());
	//SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPC", e.getPage().getActionPageName());
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPC", e.getPage().getRequest().getServletPath());
}
String pagina_corrente = (String) SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVPC");

if (pagina_precedente != null) {
	if (!pagina_corrente.equals(pagina_precedente)) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPP", pagina_precedente);
	}
}
if (e.getPage().getRequest().getParameter("MVPD")  != null) {
   SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPD",  e.getPage().getRequest().getParameter("MVPD") );
}
// Se il parametro MVVC è non nullo si utilizza comunque perchè la voce corrente (ricavata dall'elenco delle pagine abilitate) 
// in caso di voci che puntano alla stessa pagina potrebbe non essere corretta
if (e.getPage().getRequest().getParameter("MVVC")  != null) {
	voce_corrente =	e.getPage().getRequest().getParameter("MVVC");
}


// MVVC di sessione istanziata al valore della voce corrente oppure a null
// se voce corrente è vuota e la pagina attuale è diversa dalla precedente

if (voce_corrente != null) {
	SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVVC", voce_corrente);
	if (e.getPage().getRequest().getParameter("MVID")  != null) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID", e.getPage().getRequest().getParameter("MVID"));
	} else {
		if (!pagina_corrente.equals(pagina_precedente)) {
			SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID", null);
		}
	}
	if (e.getPage().getRequest().getParameter("MVID2")  != null) {
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID2", e.getPage().getRequest().getParameter("MVID2"));
	} else {
		if (!pagina_corrente.equals(pagina_precedente)) {
			SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID2", null);
		}
	}
	
} else {
	if (!pagina_corrente.equals(pagina_precedente)) {
		//System.out.println("Azzeramento variabili MVID, MVID2, MVVC ");
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVVC", null);
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID", null);
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVID2", null);
	}
}

 // Gestione variabili di sessione relative ai livelli di menu
  if (e.getPage().getRequest().getParameter("MVPD")  != null) {
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVL1",  e.getPage().getRequest().getParameter("MVL1") );
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVL2",  e.getPage().getRequest().getParameter("MVL2") );
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVL3",  e.getPage().getRequest().getParameter("MVL3") );

 }

 // Azzeramento della variabile MVWF di settaggio della directory di lavoro della pagina di selezione file
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVWF", "");
 // Azzeramento della variabile MVOPT per consentire upload di file
  SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVOPT", "");

//SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVPP", e.getPage().getRequest().getServletPath());
//End Event AfterInitialize Action Custom Code

//AfterInitialize Tail @1-FCB6E20C
    }
//End AfterInitialize Tail

//OnInitializeView Head @1-E3C15E0F
    public void onInitializeView(Event e) {
//End OnInitializeView Head

//OnInitializeView Tail @1-FCB6E20C
    }
//End OnInitializeView Tail

//BeforeShow Head @1-46046458
    public void beforeShow(Event e) {
//End BeforeShow Head

//BeforeShow Tail @1-FCB6E20C
    }
//End BeforeShow Tail

//BeforeUnload Head @1-1DDBA584
    public void beforeUnload(Event e) {
//End BeforeUnload Head

//BeforeUnload Tail @1-FCB6E20C
    }
//End BeforeUnload Tail

//AmvControlHandler Tail @1-FCB6E20C
}
//End AmvControlHandler Tail
