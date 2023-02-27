//UTENTE_CONTROLDataObjectHandler head @2-C7B1CE9B
package common.AmvUtenteNominativo_i;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.components.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class UTENTE_CONTROLDataObjectHandler implements DataObjectListener {
//End UTENTE_CONTROLDataObjectHandler head

// //BeforeBuildSelect @2-F81417CB

//beforeBuildSelect head @2-3041BA14
    public void beforeBuildSelect( DataObjectEvent e) {
//End beforeBuildSelect head

//Event BeforeBuildSelect Action Custom Code @9-44795B7A
/* -------------------------- *
 *  write your own code here  *
 * -------------------------- */

 	JDBCConnection conn = JDBCConnectionFactory.getJDBCConnection("cn");
	String mvute = Utils.convertToString(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("MVUTE"));
	String utente = Utils.convertToString(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Utente"));
	String progetto = Utils.convertToString(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("Progetto"));
	String groupid = Utils.convertToString(SessionStorage.getInstance(e.getPage().getRequest()).getAttribute("GroupID"));
	String idute = Utils.convertToString(e.getPage().getRequest().getParameter("IDUTE"));
	if (idute == null) idute = "";
	if (mvute == null) mvute = "";
	if (groupid == null) groupid = "";
	String sql = "SELECT nvl(max(u.utente),'?') UTENTE "
                    + "FROM AD4_UTENTI u "
                    + "WHERE u.UTENTE = nvl('" + idute + "','" + mvute + "') "
                    + "AND AMV_UTENTE.IS_UTENTE_VALIDO(nvl('" + idute + "','" + mvute + "'),'" + utente + "','" + progetto + "','" + groupid + "') = 1";
	DbRow row = conn.getOneRow(sql);
	conn.closeConnection();
	String utenteValido = "";
	if(row!=null) {
		utenteValido = Utils.convertToString(row.get("UTENTE"));
		SessionStorage.getInstance(e.getPage().getRequest()).setAttribute("MVUTE", utenteValido);			
	}

//End Event BeforeBuildSelect Action Custom Code

//BeforeBuildSelect Tail @2-FCB6E20C
    }
//End BeforeBuildSelect Tail

// //beforeExecuteSelect @2-F81417CB

//beforeExecuteSelect head @2-8391D9D6
    public void beforeExecuteSelect( DataObjectEvent e) {
//End beforeExecuteSelect head

//beforeExecuteSelect Tail @2-FCB6E20C
    }
//End beforeExecuteSelect Tail

// //afterExecuteSelect @2-F81417CB

//afterExecuteSelect Head @2-0972E7FA
    public void afterExecuteSelect( DataObjectEvent e) {
//End afterExecuteSelect Head

//afterExecuteSelect Tail @2-FCB6E20C
    }
//End afterExecuteSelect Tail

//UTENTE_CONTROLDataObjectHandler Tail @2-FCB6E20C
}
//End UTENTE_CONTROLDataObjectHandler Tail

