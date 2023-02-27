//Action class @0-F88B32CA
package com.codecharge;

import java.util.*;
import java.text.MessageFormat;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;
import com.codecharge.components.*;
import com.codecharge.util.*;
import com.codecharge.validation.*;

public abstract class Action {

    public static final int GET = 1;
    public static final int POST = 2;

    protected HttpServletRequest req;
    protected HttpServletResponse resp;
    protected ServletContext context;
    protected CCLogger logger;
    protected Page page;
    protected String pageName;
	protected ResourceBundle res;
    
    public Action() {
        logger = CCLogger.getInstance();
    }

    public abstract String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context );

    public String getPageName() {
        return pageName;
    }

    public void setPageName( String pageName ) {
        this.pageName = pageName;
    }
    
    protected void isSecure() {
        if ( ! req.isSecure() ) {
            //throw new SecurityException( "SSL connection error. This page could be accessed only via secured connection.");
            try {
                java.io.PrintWriter actionPw = new java.io.PrintWriter( 
                        new java.io.OutputStreamWriter( resp.getOutputStream() ));
                //actionPw.println("SSL connection error. This page can be accessed only via secured connection.");
				actionPw.println(res.getString("SSLError"));
                actionPw.flush();
                actionPw.close();
            } catch (java.io.IOException ioe) {
                ioe.printStackTrace(System.err);
            }
        }
    }
    
    protected String formPagePath( HttpServletRequest req ) {
        return req.getServerName() + ":" + req.getServerPort() + 
                req.getContextPath() + "/";
    }
    
    protected String getReturnURI( HttpServletRequest req ) {
        String reqURI = req.getRequestURI();
        if ( ContextStorage.getInstance().getAttribute( "convertReturnLinkToAbsolute" ) != null ) {
            if ( StringUtils.isEmpty( reqURI ) || reqURI.startsWith( "/" ) ) {
                reqURI = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + 
                        req.getContextPath() + "/" + reqURI.substring( req.getContextPath().length() + 1 );
            }
        }
        return reqURI;
    }
    
    protected void setBeanProperty(Component model, String property, String parameter) {
        try {
            Method m = getSetMethod(model, property);
            m.invoke(model, new String[] {page.getParameter(parameter)});
        } catch (NoSuchMethodException nsme) {
            // No method, no problem
        } catch (IllegalAccessException iae) {
            logger.error("Action::setBeanProperty: Illegal Access", iae); 
        } catch (InvocationTargetException ite) {
            logger.log(ite.getMessage(), ite);
        }
    }

    protected void setControlValue(Model m, String pname, int mode, Component component ) {
        if (m instanceof Control) {
        	Control c = (Control) m;
            try {
                if ( mode == Action.POST ) {
                    c.setValuesFromRequest( page.getHttpPostParams().getParameterValues( pname ) );
                } else {
                    c.setValuesFromRequest( page.getHttpGetParams().getParameterValues( pname ) );
                }
            } catch ( java.text.ParseException pe ) {
                if ( ! c.hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ) ) {
                	String errMsg = null;
                	if (c.getType() == ControlType.BOOLEAN || c.getType() == ControlType.DATE) {
						MessageFormat fmt = new MessageFormat(res.getString("IncorrectFormat"));
                		errMsg = fmt.format(new String[] {c.getCaption(), c.getFormatPattern()});
                	} else {
						MessageFormat fmt = new MessageFormat(res.getString("IncorrectValue"));
						errMsg = fmt.format(new String[] {c.getCaption()});
                	}
                   	c.addError(ControlErrorTypes.getErrorType(ControlErrorTypes.FORMAT_ERROR), errMsg);
                  	if ( component instanceof Grid ) {
                    	component.addError(errMsg);
                  	}
                }
            }
        }    
    }

	/**
		Set component properties. These are control values as well as properties with set methods.
		@param model Component which properties about to be set.
		@param mode Which parameters to read. POST or GET.
		@see #POST
		@see #GET
	*/
	public void setProperties(Component model, int mode) {
		setProperties(model, mode, false);
	}
	
    /**
        Set component properties. These are control values as well as properties with set methods.
        @param model Component which properties about to be set.
        @param mode Which parameters to read. POST or GET.
        @param onlyNonEditCtrls Set values for non-editable controls only
        @see #POST
        @see #GET
    */
    public void setProperties(Component model, int mode, boolean onlyNonEditCtrls ) {
        Enumeration getParams = page.getHttpGetParams().getParameterNames();
        String ccsForm = page.getHttpGetParams().getParameter( "ccsForm" );
        String fname = model.getName();
        int k;
        // Remove :Edit part to get real form name
        if ( ccsForm != null && (k = ccsForm.lastIndexOf(':')) != -1 ) {
          ccsForm = ccsForm.substring(0, k);
        }
        if ( ! StringUtils.isEmpty(ccsForm) ) {
            model.setProcessed(fname.equals( ccsForm ));
        }

        //set components properties
        if ( mode == Action.GET ) {
            while (getParams.hasMoreElements()) {
                String pname = (String) getParams.nextElement();
                if (pname.startsWith(fname)) {
                    String cname = pname.substring(fname.length());
                    setBeanProperty(model, cname, pname);
                } 
            }
        }
        Collection children = model.getChildren();

        if ( model.isProcessed() && mode == Action.POST ) {
            String formState = page.getHttpPostParams().getParameter( "FormState" );
            if ( ! StringUtils.isEmpty(formState) ) {
                model.setFormState(formState);
            }
    
            //set controls collection
            ArrayList rows = model.getChildRows();
            int pageSize = model.getPageSize();
            if ( model instanceof EditableGrid ) {
                pageSize = (int) ((EditableGrid) model).getAmountOfRows();
                pageSize += ((EditableGrid) model).getNumberEmptyRows();
            }
			MessageFormat fmtErrFmt = new MessageFormat(res.getString("IncorrectFormat"));
			MessageFormat fmtErrVal = new MessageFormat(res.getString("IncorrectValue"));
            for ( int i = 0; i < pageSize; i++ ) {
                Iterator components = children.iterator();
                boolean isEmpty = true;
                boolean isNew = false;
                HashMap row = null;
                if ( i < rows.size() ) {
                    row = (HashMap) rows.get(i);
                }
                if ( row == null ) {
                    row = new HashMap();
                    isNew = true;
                }
                while ( components.hasNext() ) {
                    Model m = (Model) components.next();
                    String pname = m.getName() + "_" + String.valueOf(i+1);
                    Control c = null;
                    String[] paramValues = null;
                    if ( mode == Action.POST ) {
                        paramValues = page.getHttpPostParams().getParameterValues( pname );
                    } else {
                        paramValues = page.getHttpGetParams().getParameterValues( pname );
                    }
                    if ( paramValues != null ) {
                        if ( m instanceof Control ) {
                            c = (Control) ((Control) m).clone();
                        }
                        if ( c != null ) {
                            isEmpty = false;
                            try {
                                c.setHtmlName(pname);
                                c.setValuesFromRequest( paramValues );
                            } catch ( java.text.ParseException pe ) {
                                if ( ! c.hasErrorByType( 
                                        ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ) ) {
                                        	
									String errMsg = null;
									if (c.getType() == ControlType.BOOLEAN || c.getType() == ControlType.DATE) {
										errMsg = fmtErrFmt.format(new String[] {c.getCaption(), c.getFormatPattern()});
									} else {
										errMsg = fmtErrVal.format(new String[] {c.getCaption()});
									}
                                    c.addError(ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ),
                                            errMsg);
                                }
                            } // end catch
                            row.put( c.getName(), c );
                        } // end if ( c!=null )
                    } // end parameter != null
                } // end while by components
                if ( ! isEmpty ) {
                    if ( isNew ) {
                        model.addChildRow( row );
                    }
                }
            } // end for
        }

        //set controls in model
        if (model instanceof EditableGrid) {
			Iterator components = ((EditableGrid) model).getStaticControls().iterator();
			while ( components.hasNext() ) {
				String name = (String) components.next();
				Model m = model.getChild(name);
				if (onlyNonEditCtrls) {
					if (model.isProcessed()) {
						if (m instanceof Control && !(m instanceof VerifiableControl)) {
							setControlValue(m, m.getName(), mode, model);
						}
					} else {
						setControlValue(m, m.getName(), mode, model);
					}
				} else {
					setControlValue(m, m.getName(), mode, model);
				}
			} // end while by components
        } else {
			Iterator components = children.iterator();
			while ( components.hasNext() ) {
				Model m = (Model) components.next();
				if (onlyNonEditCtrls) {
					if (model.isProcessed()) {
						if (m instanceof Control && !(m instanceof VerifiableControl)) {
							setControlValue(m, m.getName(), mode, model);
						}
					} else {
						setControlValue(m, m.getName(), mode, model);
					}
				} else {
					setControlValue(m, m.getName(), mode, model);
				}
			} // end while by components
        }

    }
    
    private Method getSetMethod(Model model, String prop)
            throws NoSuchMethodException {
        String methodName = "set"
            + prop.substring(0,1).toUpperCase()
            + prop.substring(1);
        return model.getClass().getMethod(methodName, new Class[] {String.class});
    }

    /** Check if logined user has enough rights **/
    protected boolean authorized (String[] groups) {
       if (req.getSession().getAttribute("UserID") != null) {
           if (groups.length > 0) {
               String group = req.getSession().getAttribute("GroupID").toString();
               if (group != null) {
                  for (int i=0; i<groups.length; i++) {
                      if (group.equals(groups[i])) return true;
                  }
               }
           } else {
               return true;
           }
       }
       return false;
    }

    protected boolean authorized (int[] groups) {
       if (req.getSession().getAttribute("UserID") != null) {
           if (groups.length > 0) {
               String group = req.getSession().getAttribute("GroupID").toString();
               int groupId = Integer.MIN_VALUE;
               try {
                    groupId = Integer.parseInt( group );
               } catch ( NumberFormatException nfe ) {
                    return false;
               }
               boolean levelInclusion = false;
               String siteLevelInclusion = null;
               Properties siteProps = (Properties) ContextStorage.getInstance()
                    .getAttribute( Names.SITE_PROPERTIES_KEY );
               if ( siteProps != null ) 
                    siteLevelInclusion = (String) siteProps.get( "levelInclusion" );
               levelInclusion = Boolean.valueOf( siteLevelInclusion ).booleanValue();
               for (int i=0; i<groups.length; i++) {
                    if ( levelInclusion ) {
                        if (groupId >= groups[i] ) return true;
                    } else {
                        if (groupId == groups[i] ) return true;
                    }    
               }
           } else {
               return true;
           }
       }
       return false;
    }

	protected boolean authorized( Page page ) {
		return (authorizedWithCode(page)==null);
	}
	
    protected String authorizedWithCode(Page page) {
        String errorCode = null;
        if ( page.isRestricted() ) {
			errorCode = "notLogged";
			boolean allowAccess = false;
            Authenticator auth = AuthenticatorFactory.getAuthenticator( req );
            if ( auth.getUserPrincipal() != null ) {
				errorCode = null;
                Permission p = page.getPermissions();
                if ( p != null && p.isUseGroup() ) {
                    String[] groups = p.getGroupsIdByPermission( Permission.ALLOW_ACCESS );
                    if ( groups != null && groups.length > 0 ) {
                        for ( int i = 0; i < groups.length; i++ ) {
                            if ( auth.isUserInRole( groups[i] ) ) {
                                allowAccess = true;
                                break;
                            }
                        }
						if (! allowAccess) {
							errorCode = "illegalGroup";
						}
                    } else {
						errorCode = "groupIDNotSet";
                    }
                } else {
                    allowAccess = true;
                }
            }
        }

        return errorCode;
    }

    /**
     *  Set allow properties in model 
     *  @param model Component model (that is Record or EditableGrid)
     *         which allow properties should be set.
     **/
    private void setActivePermissions( IRecord model ) {

        if ( model.isRestricted() ) {
            Authenticator auth = AuthenticatorFactory.getAuthenticator( req );
            if ( auth.getUserPrincipal() != null ) {
                Permission p = model.getPermissions();
                if ( p != null && p.isUseGroup() ) {
					model.setAllowRead(isAllowPermission(p, auth, model.isAllowRead(), Permission.ALLOW_ACCESS));
					model.setAllowInsert(isAllowPermission(p, auth, model.isAllowInsert(), Permission.ALLOW_INSERT));
					model.setAllowUpdate(isAllowPermission(p, auth, model.isAllowUpdate(), Permission.ALLOW_UPDATE));
					model.setAllowDelete(isAllowPermission(p, auth, model.isAllowDelete(), Permission.ALLOW_DELETE));
                }
            } else {
				model.setAllowRead( false );
				model.setAllowInsert( false );
				model.setAllowUpdate( false );
				model.setAllowDelete( false );
            }
            model.setVisible(model.isAllowRead() || model.isAllowInsert() || 
                    model.isAllowUpdate() || model.isAllowDelete());
        }

    }

	private boolean isAllowPermission(Permission p, Authenticator auth, boolean permissionValue, int permissionType) {
		boolean allowPermission = false;
		String[] groups = p.getGroupsIdByPermission( permissionType );
		if ( groups != null && groups.length > 0 ) {
			for ( int i = 0; i < groups.length; i++ ) {
				if ( auth.isUserInRole( groups[i] ) ) {
					allowPermission = true;
					break;
				}
			}
		}         
		return (allowPermission & permissionValue);           
	}

    public void setActivePermissions( Record model ) {
        setActivePermissions((IRecord) model);
    }
        
    public void setActivePermissions( EditableGrid model ) {
        setActivePermissions((IRecord) model);
    }

	/**
	 *  Set allow properties in model 
	 *  @param model Component model (that is Grid, Path, Directory or Page)
	 *         which allow properties should be set.
	 **/
    public void setActivePermissions( Component model ) {

        Authenticator auth = AuthenticatorFactory.getAuthenticator( req );
        if ( model.isRestricted() ) {
            model.setVisible( false );
            if ( auth.getUserPrincipal() != null ) {
                Permission p = model.getPermissions();
                if ( p != null && p.isUseGroup() ) {
                    String[] groups = p.getGroupsIdByPermission( Permission.ALLOW_ACCESS );
                    if ( groups != null && groups.length > 0 ) {
                        for ( int i = 0; i < groups.length; i++ ) {
                            if ( auth.isUserInRole( groups[i] ) ) {
                                model.setVisible( true );
                                break;
                            }
                        }
                    }                    
                }
            }
        }
    }

	public Control bindControlValue(Component model, HashMap hashRow, String controlName, Object value) {
		Control c = (Control) hashRow.get(controlName);
		if ( c == null ) { 
			c = (Control) model.getControl(controlName).clone();
			c.setValue(value);
			hashRow.put( c.getName(), c );
		}
		return c;
	}
	
    public static final int ALLOW_NOTHING = 0;
    public static final int ALLOW_READ = 1;
    public static final int ALLOW_UPDATE = 2;
    public static final int ALLOW_CREATE = 4;
    public static final int ALLOW_INSERT = 4;
    public static final int ALLOW_DELETE = 8;
    public static final int ALLOW_FULL = ALLOW_READ+ALLOW_UPDATE+ALLOW_CREATE+ALLOW_DELETE;
}

//End Action class

