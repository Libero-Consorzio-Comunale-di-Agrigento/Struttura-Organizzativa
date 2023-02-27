/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    05/02/2003 AO     Gestione validità della connessione
******************************************************************************/
//DBConnectionManager @0-F3740077
package com.codecharge.db;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.codecharge.util.*;
import com.codecharge.validation.*;

/**
 * This class is a Singleton that provides access to one or many
 * connection pools defined in a Property file. A client gets
 * access to the single instance through the static getInstance()
 * method and can then check-out and check-in connections from a pool.
 * When the client shuts down it should call the release() method
 * to close all open connections and do other clean up.
 */
public class DBConnectionManager {
    static private DBConnectionManager instance;       // The single instance
    static private int clients;

    private Properties siteProps;
    private Vector drivers = new Vector();
    private PrintWriter log;
    private Hashtable pools = new Hashtable();
    private CCLogger logger;

    public void setProperties( Properties siteProps ) {
      this.siteProps = siteProps;
      init();
    }

    public String getPoolStatus( String poolName ) {
        DBConnectionPool pool = (DBConnectionPool) pools.get( poolName );
        if (pool != null) {
            return pool.getPoolStatus();
        }
        return "Pool '" + poolName + "' is not available";
    }

    /**
     * Returns the single instance, creating one if it's the
     * first time this method is called.
     *
     * @return DBConnectionManager The single instance.
     */
    static synchronized public DBConnectionManager getInstance() {
        if (instance == null) {
            instance = new DBConnectionManager();
        }
        clients++;
        return instance;
    }

    /**
     * A private constructor since this is a Singleton
     */
    private DBConnectionManager() {
        logger = CCLogger.getInstance();
    }

    /**
     * Returns a connection to the named pool.
     *
     * @param name The pool name as defined in the properties file
     * @param con The Connection
     */
    public void freeConnection(String name, Connection con) {
        DBConnectionPool pool = (DBConnectionPool) pools.get(name);
        if (pool != null) {
            pool.freeConnection(con);
        }
    }

    /**
     * Returns an open connection. If no one is available, and the max
     * number of connections has not been reached, a new connection is
     * created.
     *
     * @param name The pool name as defined in the properties file
     * @return Connection The connection or null
     */
	 /*p1*/
    public Connection getConnection(String name) {
        DBConnectionPool pool = (DBConnectionPool) pools.get(name);
        if (pool != null) {
			System.out.println("pool not null");
            Connection conn = pool.getConnection(pool.getTimeout());
            if ( pool.hasErrors() ) {
                logger.error( "Unable to create connection '" + name +
                        "' to the database.<hr><b>Reason:</b><br>" +
                        pool.getErrorsAsString()
                        );
            }
            return conn;
        } else {
			System.out.println("Status del pool " + getPoolStatus(name));
		}
        logger.warn("DBConnectionManager.getConnection(\""+name+"\"): pool is null");
		System.out.println("pool name is " + name);
		System.out.println("pool IS null");
        return null;
    }

    /**
     * Returns an open connection. If no one is available, and the max
     * number of connections has not been reached, a new connection is
     * created. If the max number has been reached, waits until one
     * is available or the specified time has elapsed.
     *
     * @param name The pool name as defined in the properties file
     * @param time The number of milliseconds to wait
     * @return Connection The connection or null
     */
    public Connection getConnection(String name, long time) {
        DBConnectionPool pool = (DBConnectionPool) pools.get(name);
        if (pool != null) {
            return pool.getConnection(time);
        }
        logger.warn("DBConnectionManager.getConnection(\""+name+"\"): pool is null");
        return null;
    }

    /**
     * Closes all open connections and deregisters all drivers.
     */
    public synchronized void release() {
        // Wait until called by the last client
        if (--clients != 0) {
            return;
        }

        Enumeration allPools = pools.elements();
        while (allPools.hasMoreElements()) {
            DBConnectionPool pool = (DBConnectionPool) allPools.nextElement();
            pool.release();
        }
        Enumeration allDrivers = drivers.elements();
        while (allDrivers.hasMoreElements()) {
            Driver driver = (Driver) allDrivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                logger.info("Deregistered JDBC driver " + driver.getClass().getName());
            }
            catch (SQLException e) {
                logger.error("Can't deregister JDBC driver: " + driver.getClass().getName(), e);
            }
        }
    }

    /**
     * Creates instances of DBConnectionPool based on the properties.
     * A DBConnectionPool can be defined with the following properties:
     * <PRE>
     * &lt;poolname&gt;.url         The JDBC URL for the database
     * &lt;poolname&gt;.user        A database user (optional)
     * &lt;poolname&gt;.password    A database user password (if user specified)
     * &lt;poolname&gt;.maxconn     The maximal number of connections (optional)
     * </PRE>
     *
     * @param props The connection pool properties
     */
    private void createPools(Properties props) {
        Enumeration propNames = props.propertyNames();
        while (propNames.hasMoreElements()) {
            String name = (String) propNames.nextElement();
            if (name.endsWith(".url")) {
                String poolName = name.substring(0, name.lastIndexOf("."));
                String prPrefix = poolName + ".properties.";
                String cmdPrefix = poolName + ".sessionCommand";
                String url = props.getProperty(poolName + ".url");
                if (url == null) {
                    logger.error("No URL specified for " + poolName);
                    continue;
                }
                String user = props.getProperty(poolName + ".user");
                String password = props.getProperty(poolName + ".password");
                String maxconn = props.getProperty(poolName + ".maxconn");
                String poolTimeout = props.getProperty(poolName + ".timeout");
                int max;
                try {
                    max = Integer.valueOf(maxconn).intValue();
                }
                catch (NumberFormatException e) {
                    logger.warn("Invalid maxconn value " + maxconn + " for '" + poolName + "'. (Let maxconn=1).");
                    max = 1;
                }
                long poolTime = 0;
                try {
                    poolTime = Long.valueOf(poolTimeout).longValue();
                    if ( poolTime < 0 ) poolTime = 0;
                }
                catch (NumberFormatException e) {
                    poolTime = 0;
                }


                Properties dbProps = null;
                Enumeration prNames = props.propertyNames();
                while (prNames.hasMoreElements()) {
                    String prName = (String) prNames.nextElement();
                    if ( prName.startsWith( prPrefix ) ) {
                        if (dbProps == null ) {
                            dbProps = new Properties();
                        }
                        dbProps.setProperty( prName.substring( prPrefix.length() ), props.getProperty( prName ) );
                    }
                }

                ArrayList dbSesCmds = new ArrayList();
                int startCmd = 0;
                String cmdName = cmdPrefix + String.valueOf(startCmd++);
                while ( ! StringUtils.isEmpty(props.getProperty(cmdName)) ) {
                    dbSesCmds.add(props.getProperty(cmdName));
                    cmdName = cmdPrefix + String.valueOf(startCmd++);
                }
/* Custom AFC*/ 
				System.out.println("User assegnato al pool " + user);
				DBConnectionPool pool = null;
				if (user != null) {
                	pool = new DBConnectionPool(poolName, url, user, password, dbProps, max);
                } else {
					pool = new DBConnectionPool(poolName, url, dbProps, max);
				}
/* Custom AFC*/
				pool.setDbSessionCommands(dbSesCmds);
                pool.setTimeout(poolTime);
                if ( pool == null ) {
                    logger.info("Unable to initialize pool " + poolName);
                } else {
                    pools.put(poolName, pool);
                    logger.info("Initialized pool " + poolName);
                }
            }
        }
    }

    /**
     * Initializes the instance with its values.
     */
    private void init() {
        loadDrivers(siteProps);
        createPools(siteProps);
    }

    /**
     * Loads and registers all JDBC drivers. This is done by the
     * DBConnectionManager, as opposed to the DBConnectionPool,
     * since many pools may share the same driver.
     *
     * @param props The connection pool properties
     */
    private void loadDrivers(Properties props) {
        String driverClasses = props.getProperty("drivers");
        StringTokenizer st = new StringTokenizer(driverClasses, ";" );
        while (st.hasMoreElements()) {
            String driverClassName = st.nextToken().trim();
            try {
                Driver driver = (Driver)
                    Class.forName(driverClassName).newInstance();
                DriverManager.registerDriver(driver);
                drivers.addElement(driver);
                logger.info("Registered JDBC driver " + driverClassName);
            }
            catch (Exception e) {
                logger.error("Can't register JDBC driver: " +
                    driverClassName + ", Exception: " + e);
            }
        }
    }


    /**
     * This inner class represents a connection pool. It creates new
     * connections on demand, up to a max number if specified.
     * It also makes sure a connection is still open before it is
     * returned to a client.
     */
    class DBConnectionPool {
        private int checkedOut;
        private Vector freeConnections = new Vector();
        private int maxConn;
        private String name;
        private String password;
        private String URL;
        private String user;
        private Properties dbProps;
        private ArrayList dbSessionCommands;
        private ErrorCollection errors = new ErrorCollection();
        private long timeout;

        /**
         * Creates new connection pool.
         *
         * @param name The pool name
         * @param URL The JDBC URL for the database
         * @param user The database user, or null
         * @param password The database user password, or null
         * @param maxConn The maximal number of connections, or 0
         *   for no limit
         */
        public DBConnectionPool(String name, String URL, String user, String password,
                int maxConn) {
            this.name = name;
            this.URL = URL;
            this.user = user;
            this.password = password;
            this.maxConn = maxConn;
        }

        /**
         * Creates new connection pool.
         *
         * @param name The pool name
         * @param URL The JDBC URL for the database
         * @param user The database user, or null
         * @param password The database user password, or null
         * @param dbProps a list of arbitrary string tag/value pairs as connection arguments
         * @param maxConn The maximal number of connections, or 0
         *   for no limit
         */
        public DBConnectionPool(String name, String URL, String user, String password, Properties dbProps,
                int maxConn) {
            this.name = name;
            this.URL = URL;
            this.user = user;
            this.password = password;
            this.maxConn = maxConn;
            this.dbProps = dbProps;
        }

        /**
         * Creates new connection pool.
         *
         * @param name The pool name
         * @param URL The JDBC URL for the database
         * @param dbProps a list of arbitrary string tag/value pairs as connection arguments
         * @param maxConn The maximal number of connections, or 0
         *   for no limit
         */
        public DBConnectionPool(String name, String URL, Properties dbProps,
                int maxConn) {
            this.name = name;
            this.URL = URL;
            this.maxConn = maxConn;
            this.dbProps = dbProps;
        }

        public long getTimeout() {
            return timeout;
        }

        public void setTimeout(long timeout) {
            this.timeout = timeout;
        }

        public void setDbSessionCommands( ArrayList dbSessionCommands ) {
            this.dbSessionCommands = dbSessionCommands;
        }

        public String getPoolStatus() {
            StringBuffer sb = new StringBuffer( "Pool: " + name + "\n" );
            sb.append( "max number of connections: " );
            if ( maxConn == 0 ) {
                sb.append( "unlimited\n" );
            } else {
                sb.append( maxConn + "\n" );
            }
            sb.append( "number of allocated connections: " );
            sb.append( checkedOut + "\n" );
            return sb.toString();
        }

        /**
         * Checks in a connection to the pool. Notify other Threads that
         * may be waiting for a connection.
         *
         * @param con The connection to check in
         */
        public synchronized void freeConnection(Connection con) {
            if ( con == null ) return;
            if ( maxConn < 1 ) {
                try {
                    if ( ! con.isClosed() ) {
                        con.close();
                    }
                } catch (SQLException sqle) {
                    logger.error("DBConnectionManager.freeConnection(Connection): ", sqle);
                }
            } else {
                // Put the connection at the end of the Vector
                freeConnections.addElement(con);
            }
            checkedOut--;
            logger.debug("DBConnectionManager.freeConnection(Connection): One connection released");
            this.notifyAll();
        }

        /**
         * Checks out a connection from the pool. If no free connection
         * is available, a new connection is created unless the max
         * number of connections has been reached. If a free connection
         * has been closed by the database, it's removed from the pool
         * and this method is called again recursively.
         */
        public synchronized Connection getConnection() {
            Connection con = null;
            if (freeConnections.size() > 0) {
                // Pick the first Connection in the Vector
                // to get round-robin usage
                con = (Connection) freeConnections.firstElement();
                freeConnections.removeElementAt(0);
                try {
                    if (con.isClosed()) {
                        logger.info("Removed bad connection from " + name);
                        // Try again recursively
                        con = getConnection();
                    } else {
                        con.setAutoCommit(con.getAutoCommit());
                    }
                }
                catch (SQLException e) {
                    logger.error("Removed bad connection from " + name);
                    // Try again recursively
                    con = getConnection();
                }
// Rev.1 : Gestione Validità connessione custom AFC
		try {
		// test per verificare se la connessione è valida (con.isClosed() non è sufficiente)
        		Statement s = con.createStatement();
        		s.close();
        		s = null;
      		    } 
		catch (Exception ex)  {
					logger.error("Finmatica: Removed bad connection from " + name);
			                con = getConnection();
	        }
// Rev.1 : fine gestione validità connessione                               
            } else if (maxConn == 0 || checkedOut < maxConn) {
                con = newConnection();
            }
            if (con != null) {
                checkedOut++;
                logger.debug("DBConnectionManager.getConnection(): One connection taken");
            }
            return con;
        }

        /**
         * Checks out a connection from the pool. If no free connection
         * is available, a new connection is created unless the max
         * number of connections has been reached. If a free connection
         * has been closed by the database, it's removed from the pool
         * and this method is called again recursively.
         * <P>
         * If no connection is available and the max number has been
         * reached, this method waits the specified time for one to be
         * checked in.
         *
         * @param timeout The timeout value in milliseconds
         */
        public synchronized Connection getConnection(long timeout) {
            long startTime = new Date().getTime();
            Connection con = null;
            while ((con = getConnection()) == null) {
                try {
                    this.wait(timeout);
                }
                catch (InterruptedException e) {}
                if ((new Date().getTime() - startTime) >= timeout) {
                    // Timeout has expired
                    return null;
                }
            }
            return con;
        }

        /**
         * Closes all available connections.
         */
        public synchronized void release() {
            Enumeration allConnections = freeConnections.elements();
            while (allConnections.hasMoreElements()) {
                Connection con = (Connection) allConnections.nextElement();
                try {
                    con.close();
                    logger.info("Closed connection for pool " + name);
                }
                catch (SQLException e) {
                    logger.error("Can't close connection for pool " + name, e);
                }
            }
            freeConnections.removeAllElements();
            logger.debug("DBConnectionManager.release(): All connections were released");
        }

        /**
         * Creates a new connection, using a userid and password
         * if specified.
         */
        private Connection newConnection() {
            Connection con = null;
			System.out.println("newConnection URL " + URL);

            try {
                if ( StringUtils.isEmpty(user) ) {
 		        System.out.println("newConnection URL1 " + URL);
                    if ( this.dbProps == null || this.dbProps.size() == 0 ) {
 			            System.out.println("newConnection URL2 " + URL);
                        con = DriverManager.getConnection( URL );
 			            System.out.println("newConnection URL3 " + URL);
                   } else {
 			            System.out.println("newConnection URL4 " + URL);
                        con = DriverManager.getConnection( URL, this.dbProps );
 			            System.out.println("newConnection URL5 " + URL);
                    }
                } else {
  			       System.out.println("newConnection URL6 " + URL);
                   if ( this.dbProps == null || this.dbProps.size() == 0 ) {
 			            System.out.println("newConnection URL7 " + URL);
                        con = DriverManager.getConnection(URL, user, password);
                    } else {
                        dbProps.setProperty("user", user);
                        dbProps.setProperty("password", password);
                        con = DriverManager.getConnection( URL, this.dbProps );
                    }
                }

                if ( dbSessionCommands != null && dbSessionCommands.size() > 0 ) {
                    Statement stmt = con.createStatement();
                    for ( int i = 0; i < dbSessionCommands.size(); i++ ) {
                        try {
                            stmt.execute((String) dbSessionCommands.get(i));
                        } catch (SQLException sqle) {
                            logger.error("Error occurred while executing the initialization command: " + (String) dbSessionCommands.get(i));
                        }
                    }
                    stmt.close();
                }

                logger.info("Created a new connection in pool " + name);
            }
            catch (SQLException e) {
                logger.error("Can't create a new connection for " + URL, e);
                errors.addError("Can't create a new connection for " + URL + ".\n" + e.getMessage() );
                return null;
            }
            return con;
        }

        /** Whether Component has errors. **/
        public boolean hasErrors() {
            return ( errors.hasErrors() );
        }

        /** Get Collection of errors. **/
        public Collection getErrors() {
            return errors.getErrors();
        }

        /** Get all errors represented as one string. **/
        public String getErrorsAsString() {
            return errors.getErrorsAsString();
        }


    }
}
//End DBConnectionManager

