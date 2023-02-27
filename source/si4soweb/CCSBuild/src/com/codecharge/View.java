//View class @0-AC2645B1
package com.codecharge;

import java.util.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.util.*;
import java.io.*;
import com.codecharge.components.*;
import com.codecharge.util.*;
import com.codecharge.db.ParameterSource;
import com.codecharge.events.Event;
import com.codecharge.validation.*;

public abstract class View {

  protected HttpServletRequest req;
  protected HttpServletResponse resp;
  protected String tmplPath;
  protected Template tmpl;
  protected ServletContext context;
  protected Page page;
  protected CCLogger logger;
  protected View view;

  public View() {
    logger = CCLogger.getInstance();
  }

  public abstract String show( HttpServletRequest req, HttpServletResponse resp, ServletContext context );

  public HttpServletResponse getResponse() {
    return resp;
  }

  public HttpServletRequest getRequest() {
    return req;
  }

  public Template getTemplate() {
    return tmpl;
  }

  public void setTemplate( Template tmpl ) {
    this.tmpl = tmpl;
  }

  public void loadTemplate() {
    tmpl = new Template( context );
    tmpl.setPage(page);
    logger.info("view => loadTemplate: Looking for "+tmplPath+" template..."); 
    InputStream tmpl_stream = null;
    tmplPath = getActualTemplateName(tmplPath);
    try {
      if ( ContextStorage.getInstance().getAttribute( "usedUnpackedWarFile" ) == null ) {
        tmpl_stream = context.getResourceAsStream(tmplPath);
      } else {
        tmpl_stream = new java.io.FileInputStream( context.getRealPath( tmplPath ));
      }
    } catch ( FileNotFoundException fnfe ) {
      logger.error("view => loadTemplate: Unable to load the template"); 
    }
    if (tmpl_stream == null) {
      logger.error("view => loadTemplate: Unable to load the template"); 
    }
    tmpl.loadTemplate(tmpl_stream, "main", true);
  }

  public void loadTemplate( String name ) {
    tmpl = new Template( context );
    logger.info("view => loadTemplate: Looking for "+name+" template..."); 
    InputStream tmpl_stream = null;
    name = getActualTemplateName(name);
    try {
       if ( ContextStorage.getInstance().getAttribute( "usedUnpackedWarFile" ) == null ) {
         tmpl_stream = context.getResourceAsStream( name );
       } else {
         tmpl_stream = new java.io.FileInputStream( context.getRealPath( name ));
       }
    } catch ( FileNotFoundException fnfe ) {
      logger.error("view => loadTemplate: Unable to load the template"); 
    }
    if (tmpl_stream == null) {
      logger.error("view => loadTemplate: Unable to load the template"); 
    }
    tmpl.loadTemplate(tmpl_stream, "main", true);
  }

  protected String getActualTemplateName(String name) {
      if (StringUtils.isEmpty(name)) return name;
      String result = name;
      if (tmpl != null && tmpl.isUseLocalizatedTemplate()) {
        String encoding = page.getCharacterEncoding();
        if (encoding != null && encoding.length() != 0) {
            try {
                byte[] tmp = "test".getBytes(encoding); 
            } catch (java.io.UnsupportedEncodingException uee) {
                encoding = null;
            }
        } else {
            encoding = null;
        }
        Locale locale = page.getLocale();
        String language = (StringUtils.isEmpty(locale.getLanguage()) ? "" : "_"+locale.getLanguage()); 
        String country = (StringUtils.isEmpty(locale.getCountry()) ? "" : "_"+locale.getCountry()); 
        String variant = (StringUtils.isEmpty(locale.getVariant()) ? "" : "_"+locale.getVariant());
        encoding = (StringUtils.isEmpty(encoding) ? "" : "_"+encoding);

        String[] suffixes = new String[5];
        suffixes[0] = name;
        int pos = name.lastIndexOf(".");
        String ext = "";
        if (pos>-1) {
            ext = name.substring(pos); 
            name = name.substring(0, pos);
        }
        suffixes[1] = name + language + ext;
        suffixes[2] = name + language + country + ext;
        suffixes[3] = name + language + country + encoding + ext;
        suffixes[4] = name + language + country + variant + encoding + ext;
        int i = suffixes.length;
        InputStream tmpl_stream = null;
        Object useWarFile = ContextStorage.getInstance().getAttribute("usedUnpackedWarFile");
        for (i = suffixes.length - 1; i > -1; i--) {
            try {
                if (useWarFile == null) {
                  tmpl_stream = context.getResourceAsStream( suffixes[i] );
                } else {
                  tmpl_stream = new java.io.FileInputStream( context.getRealPath( suffixes[i] ));
                }
            } catch (FileNotFoundException fnfe) {
                continue;
            }
            if (tmpl_stream != null) {
                result = suffixes[i];
                tmpl_stream = null;
                break;
            }
        }
      }
      return result;
  }

  public String getFileContent( String name ) throws java.io.IOException {
    String fileName = "/" + name;
    StringBuffer lines = new StringBuffer();
    logger.info("view => getFileContent: Looking for '/"+name+"' file...");
    InputStream fileStream = null;
    try {
      if ( ContextStorage.getInstance().getAttribute( "usedUnpackedWarFile" ) == null ) {
        fileStream = context.getResourceAsStream(name);
      } else {
        fileStream = new java.io.FileInputStream( context.getRealPath( name ));
      }
    } catch ( FileNotFoundException fnfe ) {
      logger.error("view => loadTemplate: Unable to load the template"); 
    }
    if ( fileStream == null) {
      logger.error("view => getFileContent: Unable to load the file '/" + name + "'"); 
      throw new java.io.IOException( this.getClass().getName() + ".getFileContent(): File '/" + name + "' is not found"); 
    }
    else {
      java.io.BufferedReader bf = new java.io.BufferedReader(
              new java.io.InputStreamReader( fileStream));
      while (bf.ready()) {
        String line = bf.readLine();
        if ( line != null ) { lines.append( line + "\n"); }
      }
      bf.close();
    }
    return lines.toString();
  }

  public String getHttpContent ( String url )
          throws java.net.MalformedURLException, java.io.IOException {

    String nextLine;
    StringBuffer webPage;

    java.net.URL siteURL = new java.net.URL ( url );
    java.net.URLConnection siteConn = siteURL.openConnection();
    java.io.BufferedReader in = new java.io.BufferedReader (
            new java.io.InputStreamReader( siteConn.getInputStream() ) );

    webPage = new StringBuffer();
    while ( ( nextLine = in.readLine() ) != null ) { webPage.append(nextLine); }
    in.close();

    return webPage.toString();
  }

	public void show(Model model) {
		if (model instanceof FileUpload) {
			show((FileUpload) model);		
		} else if (model instanceof Button) {
			show((Button) model);		
		} else if (model instanceof ImageLink) {
			show((ImageLink) model);		
		} else if (model instanceof Link) {
			show((Link) model);		
		} else if (model instanceof CheckBoxList) {
			show((CheckBoxList) model);		
		} else if (model instanceof ListBox) {
			show((ListBox) model);		
		} else if (model instanceof RadioButton) {
			show((RadioButton) model);		
		} else if (model instanceof DatePicker) {
			show((DatePicker) model);		
		} else if (model instanceof Control) {
			show((Control) model);		
		} else if (model instanceof Navigator) {
			show((Navigator) model);
		} else if (model instanceof Sorter) {
			show((Sorter) model);
		}
	}
	
	public void show(String subBlockName, Model model) {
		if (model instanceof FileUpload) {
			show(subBlockName, (FileUpload) model);		
		} else if (model instanceof Button) {
			show(subBlockName, (Button) model);		
		} else if (model instanceof ImageLink) {
			show(subBlockName, (ImageLink) model);		
		} else if (model instanceof Link) {
			show(subBlockName, (Link) model);		
		} else if (model instanceof CheckBoxList) {
			show(subBlockName, (CheckBoxList) model);		
		} else if (model instanceof ListBox) {
			show(subBlockName, (ListBox) model);		
		} else if (model instanceof RadioButton) {
			show(subBlockName, (RadioButton) model);		
		} else if (model instanceof DatePicker) {
			show(subBlockName, (DatePicker) model);		
		} else if (model instanceof Control) {
			show(subBlockName, (Control) model);		
		} else if (model instanceof Navigator) {
			show((Navigator) model);
		} else if (model instanceof Sorter) {
			show((Sorter) model);
		}
	}

  public void show(Control model) {
    if (model instanceof FileUpload) {
        show(null, (FileUpload) model);
    } else {
        show(null, model);
    }
  }

  public void show(ListBox model) {
    show(null, model);
  }

  public void show(Link model) {
    show(null, model);
  }

  public void show(ImageLink model) {
    show(null, model);
  }

  public void show(RadioButton model) {
    show(null, model);
  }

  public void show(CheckBoxList model) {
    show(null, model);
  }

  public void show(FileUpload model) {
    show(null, model);
  }
  
  public void show(String subBlockName, FileUpload model) {
    if ( subBlockName == null ) subBlockName = "";
    String blockToParse = "FileUpload "+model.getName();
    if ( model.isVisible() ) {
        model.fireBeforeShowEvent(new Event());
    }
    String pathTo = page.getCurrentPath()+subBlockName;
    tmpl.setTag(pathTo, blockToParse);
    if ( model.isVisible() ) {
        StringBuffer fileName = new StringBuffer(model.getHtmlName());
        fileName.insert(model.getName().length(),"_File");
        tmpl.setTag(pathTo, blockToParse + "/@ControlName", model.getHtmlName());
        tmpl.setTag(pathTo, blockToParse + "/@State", model.getState());
        if (model.isUploaded()) {
            tmpl.setTag(pathTo, blockToParse + "/Info/@FileName", model.getFileName());
            tmpl.setTag(pathTo, blockToParse + "/Info/@FileSize", String.valueOf(model.getSize()));
            tmpl.render(pathTo, blockToParse + "/Info", false);

            if (model.isRequired()) {
                tmpl.setTag(pathTo, blockToParse + "/DeleteControl");
                tmpl.setTag(pathTo, blockToParse + "/Upload/@FileControl", fileName.toString());
                tmpl.render(pathTo, blockToParse + "/Upload", false);
            } else {
                tmpl.setTag(pathTo, blockToParse + "/Upload");
                StringBuffer delName = new StringBuffer(model.getHtmlName());
                delName.insert(model.getName().length(),"_Delete");
                tmpl.setTag(pathTo, blockToParse + "/DeleteControl/@DeleteControl", delName.toString());
                if (model.getDelete()) {
                    tmpl.setTag(pathTo, blockToParse + "/DeleteControl/@DeleteChecked", "CHECKED");
                } else {
                    tmpl.setTag(pathTo, blockToParse + "/DeleteControl/@DeleteChecked", "");
                }
                tmpl.render(pathTo, blockToParse + "/DeleteControl", false);
            }
        } else {
            tmpl.setTag(pathTo, blockToParse + "/Info");
            tmpl.setTag(pathTo, blockToParse + "/DeleteControl");
            tmpl.setTag(pathTo, blockToParse + "/Upload/@FileControl", fileName.toString());
            tmpl.render(pathTo, blockToParse + "/Upload", false);
        }
        tmpl.render(pathTo, blockToParse, false);
    }
  }


  public void show(String subBlockName, Control model) {
    if ( subBlockName == null ) subBlockName = "";
    if ( model.isVisible() ) {
        model.fireBeforeShowEvent(new Event());
    }
    if ( model.isVisible() ) {
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name", model.getHtmlName());
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName(), model.getFormattedValue());
    } else {
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name");
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName());
        String controlType = model.getClass().getName();
        controlType = controlType.substring( controlType.lastIndexOf(".")+1 );
        tmpl.setTag(page.getCurrentPath()+subBlockName, controlType + " " + model.getName());
    }
  }

	protected void setLinkParameters(Link model) {
	  	StringBuffer href = new StringBuffer();
	  	Page page = model.getPage();
	  	for (Iterator i = model.getParameters().iterator(); i.hasNext(); ) {
			LinkParameter param = (LinkParameter)i.next();
			ParameterSource type = param.getSourceType();
			if (type == ParameterSource.URL) {
		  		param.setValue( page.getHttpGetParameters().getParameterValues(param.getSourceName()));
			} else if (type == ParameterSource.FORM) {
		  		param.setValue( page.getHttpPostParameters().getParameterValues(param.getSourceName()));
			} else if (type == ParameterSource.SESSION) {
		  		param.setValue( SessionStorage.getInstance(page.getRequest()).getAttribute(param.getSourceName()));
			} else if (type == ParameterSource.APPLICATION) {
		  		param.setValue( ContextStorage.getInstance().getAttribute(param.getSourceName()));
			} else if (type == ParameterSource.COOKIE) {
		  		param.setValue( page.getCookie( param.getSourceName()));
			}
	  	}
	}

    public void show(String subBlockName, Link model) {
        if ( subBlockName == null ) subBlockName = "";
        if ( model.isVisible() ) {
			setLinkParameters(model);
            model.fireBeforeShowEvent(new Event());
        }
        if ( model.isVisible() ) {
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name", model.getHtmlName());
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName(), model.getFormattedValue() );
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName() + "_Src", SessionStorage.getInstance( page.getRequest() ).encodeURL( model.getHref() ) );
        } else {
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name");
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName());
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName() + "_Src", SessionStorage.getInstance( page.getRequest() ).encodeURL( model.getHref() ) );
            tmpl.setTag(page.getCurrentPath()+subBlockName, "Link " + model.getName());
        }
    }

  public void show(String subBlockName, ImageLink model) {
    if ( subBlockName == null ) subBlockName = "";
    if ( model.isVisible() ) {
		setLinkParameters(model);
        model.fireBeforeShowEvent(new Event());
    }
    if ( model.isVisible() ) {
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name", model.getHtmlName());
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName() + "_Src", model.getFormattedValue() );
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName(), SessionStorage.getInstance( page.getRequest() ).encodeURL( model.getHref() ) );
    } else {
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name");
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName() + "_Src", model.getFormattedValue() );
        tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName(), SessionStorage.getInstance( page.getRequest() ).encodeURL( model.getHref() ) );
        tmpl.setTag(page.getCurrentPath()+subBlockName, "ImageLink " + model.getName());
    }
  }

    public void show(String subBlockName, ListBox model) {
        if ( subBlockName == null ) subBlockName = "";
        if ( model.isVisible() ) {
            model.fireBeforeShowEvent(new Event());
        }
        if ( model.isVisible() ) {
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name", model.getHtmlName());
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Options", model.getOptionsString() );
        } else {
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Name");
            tmpl.setTag(page.getCurrentPath()+subBlockName, "@"+model.getName()+"_Options", model.getOptionsString() );
            tmpl.setTag(page.getCurrentPath()+subBlockName, "ListBox " + model.getName());
        }
    }

    public void show(String subBlockName, RadioButton model) {
        if ( subBlockName == null ) subBlockName = "";
        String pathTo = page.getCurrentPath() + subBlockName;
        String blockToParse = "RadioButton "+model.getName();
        tmpl.setTag(pathTo, "RadioButton "+model.getName());
        if ( model.isVisible() ) {
            model.fireBeforeShowEvent(new Event());
        }
        if ( model.isVisible() ) {
            Enumeration enumeration = model.getFormattedOptions();

            while ( enumeration.hasMoreElements() ) {
                String[] option = (String[]) enumeration.nextElement();

                if (option[com.codecharge.components.List.SELECTED] != null) {
                    tmpl.setTag( pathTo, blockToParse + "/@Check", "CHECKED" );
                } else {
                    tmpl.setTag( pathTo, blockToParse + "/@Check" );
                }
                tmpl.setTag( pathTo, blockToParse +"/@Value", 
                        option[com.codecharge.components.List.BOUND_COLUMN] );
                tmpl.setTag( pathTo, blockToParse +"/@Description", 
                        option[com.codecharge.components.List.TEXT_COLUMN] );
                tmpl.setTag( pathTo, blockToParse +"/@"+model.getName()+"_Name", 
                        model.getHtmlName());
                tmpl.render( pathTo, blockToParse, true );
            }
        }
    }

    public void show(String subBlockName, CheckBoxList model) {
        if ( subBlockName == null ) subBlockName = "";
        String pathTo = page.getCurrentPath() + subBlockName;
        String blockToParse = "CheckBoxList "+model.getName();
        tmpl.setTag(pathTo, "CheckBoxList "+model.getName());
        if ( model.isVisible() ) {
            model.fireBeforeShowEvent(new Event());
        }
        if ( model.isVisible() ) {
            Enumeration enumeration = model.getFormattedOptions();

            while ( enumeration.hasMoreElements() ) {
                String[] option = (String[]) enumeration.nextElement();

                if (option[com.codecharge.components.List.SELECTED] != null) {
                    tmpl.setTag( pathTo, blockToParse + "/@Check", "CHECKED" );
                } else {
                    tmpl.setTag( pathTo, blockToParse + "/@Check" );
                }
                tmpl.setTag( pathTo, blockToParse +"/@Value", 
                        option[com.codecharge.components.List.BOUND_COLUMN] );
                tmpl.setTag( pathTo, blockToParse +"/@Description", 
                        option[com.codecharge.components.List.TEXT_COLUMN] );
                tmpl.setTag( pathTo, blockToParse +"/@"+model.getName()+"_Name", 
                        model.getHtmlName());
                tmpl.render( pathTo, blockToParse, true );
            }
        }
    }

    public void show(Button model) {
        show(null,model);
    }

    public void show(String subBlockName, Button model) {
        if ( subBlockName == null ) subBlockName = "";
        String pathTo = page.getCurrentPath() + subBlockName;
        String blockToParse = "Button "+model.getName();
        Component parent = model.getParent();
        if (parent instanceof Record) {
        	Record r = (Record) parent;
        	if (r.isEditMode()) {
        		if ("Insert".equals(model.getOperation())) {
        			model.setVisible(false);
        		}
        	} else {
				if ("Update".equals(model.getOperation()) || "Delete".equals(model.getOperation())) {
					model.setVisible(false);
				}
        	}
        }
        if ( model.isVisible() ) {
            model.fireBeforeShowEvent(new Event());
        }
        if ( model.isVisible() ) {
            tmpl.setTag( pathTo, blockToParse + "/@Button_Name", model.getHtmlName() );
            tmpl.render( pathTo, blockToParse, false, Template.IF_DOESNT_EXIST_DO_NOTHING );
        } else {
            tmpl.setTag( pathTo, blockToParse );
        }
    }

    public void show(DatePicker model) {
        show(null,model);
    }

    public void show(String subBlockName, DatePicker model) {
        if ( subBlockName == null ) subBlockName = "";
        String pathTo = page.getCurrentPath() + subBlockName;
        String blockToParse = "DatePicker "+model.getName();
        if ( model.isVisible() ) {
            tmpl.setTag( pathTo, blockToParse + "/@DateControl", model.getParent().getControl(model.getControlName()).getHtmlName() );
            tmpl.setTag( pathTo, blockToParse + "/@FormName", model.getParent().getName() );
            tmpl.setTag( pathTo, blockToParse + "/@Name", model.getParent().getName() + "_" + model.getName() );
            tmpl.render( pathTo, blockToParse, false, Template.IF_DOESNT_EXIST_DO_NOTHING );
        } else {
            tmpl.setTag( pathTo, blockToParse );
        }
    }

    /**
        Show Navigator.
        @param subBlockName the block in which this Navigator appeares.
        @param model Model of the Navigator we want to show.
        @param type Type of the Navigator SIMPLE, CENTERED, MOVING.
           SIMPLE shows [c] of [t]
           CENTERED shows [c-1] [c] [c+1] of [t]
           MOVING shows [c-2] [c-1] [c] of [t]
        @param size Number of pages available for navigation.
        @param queryString Query that will be added to Navigator links.
    */
    public void show(Navigator model, int type) {
        String blockToParse = page.getCurrentPath() + "/Navigator " + model.getName();
        if (model.isVisible()) {
            model.fireBeforeShowEvent(new Event());
        }
        if (model.isVisible()) {
            String query = model.getQuery(page.getHttpGetParams());
            HttpServletResponse resp = page.getResponse();
            Grid grid = (Grid)model.getParent();
            String gridName = grid.getName();
            query = StringUtils.isEmpty(query) ? "" : "&" + query;
            int size = grid.getFetchSize();
            int curPage = grid.getPage();
            if ( curPage < 1 ) curPage = 1;
            int lastPage = (int) (grid.getAmountOfRows()-1)/size + 1;

            if (curPage == 1) {
                tmpl.parse(blockToParse+"/First_Off", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/Prev_Off", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.setVar(blockToParse+"/First_On");
                tmpl.setVar(blockToParse+"/Prev_On");
            } else {
                tmpl.setVar(blockToParse+"/First_Off");
                tmpl.setVar(blockToParse+"/Prev_Off");
                tmpl.setVar(blockToParse+"/First_On/@First_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?" + gridName + "Page=1" + query), Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/First_On", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.setVar(blockToParse+"/Prev_On/@Prev_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?" + gridName + "Page=" + (curPage-1) + query), Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/Prev_On", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
            }

            int start, end;
            switch (type) {
                case Navigator.SIMPLE:
                    start = 1; 
                    end = 0;
                    break;
                case Navigator.CENTERED:
                    start = curPage - model.getNumberOfPages()/2; 
                    end = start + model.getNumberOfPages() - 1;
                    if (start < 1) {
                        start = 1; 
                        end = model.getNumberOfPages() > lastPage ? lastPage : model.getNumberOfPages();
                    }
                    if (end > lastPage) {
                        end = lastPage; 
                        start = lastPage - model.getNumberOfPages() + 1 < 1 ? 1 : lastPage - model.getNumberOfPages() +1;
                    }
                    break;
                case Navigator.MOVING:
                    start = ((curPage-1)/size)*size + 1; 
                    end = start + size -1;
                    if (end > lastPage) end = lastPage;
                    break;
                default:
                    start = 1; 
                    end = 0;
            }
            for (int i = start; i <= end ; i++) {
                if (i == curPage) {
                    tmpl.setVar(blockToParse+"/Pages/Page_Off/@Page_Number", String.valueOf(i), Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.parse(blockToParse+"/Pages/Page_Off", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.setVar(blockToParse+"/Pages/Page_On", "", Template.IF_DOESNT_EXIST_DO_NOTHING);
                } else {
                    tmpl.setVar(blockToParse+"/Pages/Page_On/@Page_Number", String.valueOf(i), Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.setVar(blockToParse+"/Pages/Page_On/@Page_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?" + gridName + "Page=" + i + query), Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.parse(blockToParse+"/Pages/Page_On", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.setVar(blockToParse+"/Pages/Page_Off", "", Template.IF_DOESNT_EXIST_DO_NOTHING);
                }
                tmpl.parse(blockToParse+"/Pages", true, Template.IF_DOESNT_EXIST_DO_NOTHING);
            }
    
            tmpl.setVar(blockToParse+"/@Page_Number", String.valueOf(curPage), Template.IF_DOESNT_EXIST_DO_NOTHING);
            tmpl.setVar(blockToParse+"/@Total_Pages", String.valueOf(lastPage), Template.IF_DOESNT_EXIST_DO_NOTHING);
    
            if (curPage == lastPage) {
                tmpl.setVar(blockToParse+"/Last_On");
                tmpl.setVar(blockToParse+"/Next_On");
                tmpl.parse(blockToParse+"/Last_Off", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/Next_Off", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
            } else {
                tmpl.setVar(blockToParse+"/Last_Off");
                tmpl.setVar(blockToParse+"/Next_Off");
                tmpl.setVar(blockToParse+"/Last_On/@Last_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?" + gridName + "Page=" + lastPage + query), Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/Last_On", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.setVar(blockToParse+"/Next_On/@Next_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?" + gridName + "Page=" + (curPage+1) + query), Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.parse(blockToParse+"/Next_On", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
            }
            tmpl.parse(blockToParse, true);
        } else {
            tmpl.setVar(blockToParse);
        }
    }

	public void show(Navigator model) {
		show(model, model.getNavigatorType());
	}
	    
    public void show(Sorter model) {
        String blockToParse = page.getCurrentPath() + "/Sorter " + model.getName();
        if (model.isVisible()) {
            model.fireBeforeShowEvent(new Event());
        }
        if (model.isVisible()) {
            String query = model.getQuery(page.getHttpGetParams());
            HttpServletResponse resp = page.getResponse();
            query = StringUtils.isEmpty(query) ? "" : "&" + query;
            Grid grid = (Grid)model.getParent();
            String gridName = grid.getName();
            String order;
            String ascOn = blockToParse+"/Asc_On";
            String dscOn = blockToParse+"/Desc_On";
            String ascOff = blockToParse+"/Asc_Off";
            String dscOff = blockToParse+"/Desc_Off";
            String sort = grid.getSort();
            String dir = grid.getDir();
            if (sort != null && sort.equals(model.getName())) {
                if (dir == null || dir.equalsIgnoreCase("asc")) {
                    tmpl.parse(ascOn, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.setVar(ascOff);
                    tmpl.setVar(dscOn);
                    tmpl.setVar(dscOff+"/@Desc_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?"+gridName+"Order="+model.getName()+"&"+gridName+"Dir=DESC"+query), 1);
                    tmpl.parse(dscOff, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                } else if (dir.equalsIgnoreCase("desc")) {
                    tmpl.setVar(ascOn);
                    tmpl.setVar(dscOff);
                    tmpl.parse(dscOn, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                    tmpl.setVar(ascOff+"/@Asc_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?"+gridName+"Order="+model.getName()+"&"+gridName+"Dir=ASC"+query), 1);
                    tmpl.parse(ascOff, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                }
            } else {
                tmpl.setVar(ascOn);
                tmpl.setVar(dscOn);
                tmpl.setVar(ascOff+"/@Asc_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?"+gridName+"Order="+model.getName()+"&"+gridName+"Dir=ASC"+query), 1);
                tmpl.parse(ascOff, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
                tmpl.setVar(dscOff+"/@Desc_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?"+gridName+"Order="+model.getName()+"&"+gridName+"Dir=DESC"+query), 1);
                tmpl.parse(dscOff, false, Template.IF_DOESNT_EXIST_DO_NOTHING);
            }
            if (sort == null) {
                order = "ASC";
            } else if (sort.equals(model.getName()) && dir.equalsIgnoreCase("ASC")) {
                order = "DESC";
            } else {
                order = "ASC";
            }
            tmpl.setVar(blockToParse+"/@Sort_URL", SessionStorage.getInstance( page.getRequest() ).encodeURL(page.getActionPageName()+".do?"+gridName+"Order="+model.getName()+"&"+gridName+"Dir="+order+query), Template.IF_DOESNT_EXIST_DO_NOTHING);
            tmpl.parse(blockToParse, false);
        } else {
            tmpl.setVar(blockToParse);
        }
    }

	public void show(Record model) {
		  page.setCurrentBlock("Record "+model.getName());
		  if ( ! model.isVisible() ) {
			  tmpl.setVar( page.getCurrentPath() );
			  page.gotoParentBlock();
			  return;
		  }
		  for ( Iterator it = model.getChildren().iterator(); it.hasNext(); ) {
			  com.codecharge.components.Model m = (com.codecharge.components.Model) it.next();
			  if ( m instanceof com.codecharge.components.Control && ((com.codecharge.components.Control) m).hasErrors() ) {
				  model.addError(((com.codecharge.components.Control) m).getErrorsAsString());
			  } else if ( m instanceof com.codecharge.components.VerifiableControl && ((com.codecharge.components.VerifiableControl) m).hasErrors() && ((com.codecharge.components.VerifiableControl) m).getErrorControlName() == null) {
				  model.addError(((com.codecharge.components.Control) m).getErrorsAsString());
			  }
		  }
		  if ( model.hasErrors() ) {
			  tmpl.setVar( page.getCurrentPath() + "/Error/@Error", model.getErrorsAsString(), Template.IF_DOESNT_EXIST_DO_NOTHING );
			  tmpl.render( page.getCurrentPath() + "/Error", false, Template.IF_DOESNT_EXIST_DO_NOTHING );
		  } else {
			  tmpl.setVar( page.getCurrentPath() + "/Error" );
		  }
		  if (model.hasNextRow()) model.nextRow();
		  model.fireBeforeShowEvent( new Event() );
		  if ( ! model.isVisible() ) {
			  tmpl.setVar( page.getCurrentPath() );
			  page.gotoParentBlock();
			  return;
		  }

		  for (Iterator controls = model.getChildren().iterator(); controls.hasNext(); ) {
			  com.codecharge.components.Model m = (com.codecharge.components.Model) controls.next();
			  if (m instanceof com.codecharge.components.VerifiableControl) {
				  com.codecharge.components.VerifiableControl v = (com.codecharge.components.VerifiableControl) m;
				  if (! StringUtils.isEmpty(v.getErrorControlName()) ) {
					  String errVal = model.getControl(v.getErrorControlName()).getFormattedValue();
					  model.getControl(v.getErrorControlName()).setFormattedValue(errVal + v.getErrorsAsString());
				  }
			  }
		  }
            
		  for (Iterator controls = model.getChildren().iterator(); controls.hasNext(); ) {
			  view.show((com.codecharge.components.Model) controls.next());
		  }

            
		  StringBuffer formAction = new StringBuffer( page.getActionPageName() + ".do?ccsForm=" + model.getName() ); 
		  if (model.isEditMode()) {
			  formAction.append(":Edit");
		  }
		  HashMap parameters = new HashMap();
		  if ((model.getPreserveType()==PreserveParameterType.POST || model.getPreserveType()==PreserveParameterType.ALL) && page.getHttpGetParameter("ccsForm")==null) {
			  parameters.putAll(page.getHttpPostParams().getPreserveParameters( model.getExcludeParams() ));
		  }
		  Vector getExclude = new Vector();
		  getExclude.add("ccsForm");
		  parameters.putAll(page.getHttpGetParams().getPreserveParameters(getExclude));
		  Iterator params = parameters.values().iterator();
		  while(params.hasNext()) {
			  formAction.append("&"+((String)params.next()));
		  }
		  tmpl.setVar( page.getCurrentPath() + "/@Action", SessionStorage.getInstance( page.getRequest() ).encodeURL(formAction.toString()) );
		  tmpl.setVar( page.getCurrentPath() + "/@HTMLFormName", model.getName() );
		  tmpl.setVar( page.getCurrentPath() + "/@HTMLFormEnctype", model.getFormEnctype() );
		  if ( model.isVisible() ) {
			  tmpl.render( page.getCurrentPath(), false );
		  } else {
			  tmpl.setVar( page.getCurrentPath() );
		  }
		  page.gotoParentBlock();
	}
	
	public void show(Grid model, Collection staticControls, Collection rowControls, 
			Collection altRowControls, boolean hasAltRow, boolean hasSeparator) {
		page.setCurrentBlock("Grid " + model.getName());
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}
		model.fireBeforeShowEvent( new Event() );
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}
		if ( model.hasErrors() ) {
			tmpl.setVar( page.getCurrentPath(), "Form: "+model.getName()+"<br>Errors:<br>" + model.getErrorsAsString() );
			page.gotoParentBlock();
			return;
		}
		if ( model.isEmpty() ) {
			tmpl.render(page.getCurrentPath()+"/NoRecords", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
			tmpl.setVar(page.getCurrentPath()+"/Row");
			tmpl.setVar(page.getCurrentPath()+"/AltRow");
		} else {
			tmpl.setVar(page.getCurrentPath()+"/NoRecords");
		}

		boolean alt = false;
		model.initializeRows();
		while ( model.hasNextRow() ) {
			HashMap row = model.nextRow();
			model.fireBeforeShowRowEvent( new Event() );
			if ( (hasAltRow && ! alt) || !hasAltRow ) {
				for (Iterator it = rowControls.iterator(); it.hasNext(); ) {
					view.show("/Row", model.getChild((String) it.next()));
				}
				tmpl.render(page.getCurrentPath()+"/Row", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
			} else if (hasAltRow && alt) {	
				for (Iterator it = altRowControls.iterator(); it.hasNext(); ) {
					view.show("/AltRow", model.getChild((String) it.next()));
				}
				tmpl.render(page.getCurrentPath()+"/AltRow", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
			}
			alt = !alt;
	
			if ( hasSeparator && model.hasNextRow() ) {
				tmpl.render(page.getCurrentPath()+"/Separator", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
			}

		}
		model.nullChildRow();
		for (Iterator it = staticControls.iterator(); it.hasNext(); ) {
			view.show(model.getChild((String) it.next()));
		}

		if ( model.isVisible() ) {
			tmpl.setVar(page.getCurrentPath()+"/AltRow");
			tmpl.setVar(page.getCurrentPath()+"/Separator");
			tmpl.render(page.getCurrentPath(), false);
		} else {
			tmpl.setVar(page.getCurrentPath() );
		}
                
		page.gotoParentBlock();
	}

	public void show(Path model, Collection staticControls, 
			Collection pathControls, Collection currentControls) {

		if (staticControls==null) staticControls = new ArrayList();
		if (pathControls==null) pathControls = new ArrayList();
		if (currentControls==null) currentControls = new ArrayList();

		page.setCurrentBlock("Path " + model.getName());
		if ( ! model.isVisible() ) {
		  	tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}
		model.fireBeforeShowEvent( new Event() );
	  	if ( ! model.isVisible() ) {
		  	tmpl.setVar( page.getCurrentPath() );
		  	page.gotoParentBlock();
		  	return;
	  	}
		if ( model.hasErrors() ) {
			tmpl.setVar( page.getCurrentPath(), "Form: Path_directory_categories<br>Errors:<br>" + model.getErrorsAsString() );
			page.gotoParentBlock();
			return;
		}
		showControls(model, staticControls);

		tmpl.setVar(page.getCurrentPath()+"/PathComponent");
		/*if (hasSeparator && staticControls.iterator().hasNext() ) {
			if ( model.hasNextRow() ) {
				tmpl.render(page.getCurrentPath()+"/PathSeparator", true, page.getCurrentPath()+"/PathComponent", Template.IF_DOESNT_EXIST_DO_NOTHING);
			}
		}*/

		model.initializeRows();
		tmpl.setVar(page.getCurrentPath()+"/CurrentCategory");
		while ( model.hasNextRow() ) {
			HashMap row = model.nextRow();

			model.fireBeforeShowCategoryEvent( new Event() );

			if ( model.hasNextRow() ) {
				showControls(model, pathControls);
				tmpl.render(page.getCurrentPath()+"/PathComponent", true, page.getCurrentPath()+"/PathComponent", Template.IF_DOESNT_EXIST_DO_NOTHING);
			} else {
				showControls(model, currentControls);
				tmpl.render(page.getCurrentPath()+"/CurrentCategory", Template.IF_DOESNT_EXIST_DO_NOTHING);
			}
		}
		tmpl.render(page.getCurrentPath(), Template.IF_DOESNT_EXIST_DO_NOTHING);
		page.gotoParentBlock();
	}
	
	public void show(Directory model, Collection staticControls, Collection categoryControls, 
			Collection subcategoryControls, Collection subcattailControls, 
			boolean hasCatSeparator, boolean hasSubCatSeparator) {
		page.setCurrentBlock("Directory " + model.getName());
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}

		model.fireBeforeShowEvent( new Event() );
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}
		if ( model.hasErrors() ) {
			tmpl.setVar( page.getCurrentPath(), "Form: "+model.getName()+"<br>Errors:<br>" + model.getErrorsAsString() );
			page.gotoParentBlock();
			return;
		}
		if ( model.isEmpty() ) {
			tmpl.render(page.getCurrentPath()+"/NoCategories", false, tmpl.IF_DOESNT_EXIST_DO_NOTHING);
			tmpl.setVar(page.getCurrentPath()+"/Category");
			tmpl.setVar(page.getCurrentPath()+"/CategorySeparator");
			tmpl.setVar(page.getCurrentPath()+"/ColumnSeparator");
			page.gotoParentBlock();
			return;
		} else {
			tmpl.setVar(page.getCurrentPath()+"/NoCategories");
		}

		view.showControls(model, staticControls);

		model.initializeRows();
		tmpl.setVar(page.getCurrentPath()+"/Category");
		tmpl.setVar(page.getCurrentPath()+"/CategorySeparator");
		while ( model.hasNextRow() ) {
			HashMap row = model.nextRow();
//System.out.println("row: "+row);
			tmpl.setVar(page.getCurrentPath()+"/ColumnSeparator");
			tmpl.setVar(page.getCurrentPath()+"/Category/SubcategoriesTail");
			if ( model.isShowCategory() ) {
				if (hasSubCatSeparator) {
					tmpl.setVar(page.getCurrentPath()+"/Category/SubcategorySeparator");
				}
//System.out.println("model.getCurrentCategoryNumber(): "+model.getCurrentCategoryNumber());-->
				if ( model.getCurrentCategoryNumber() > 1 ) {
//System.out.println("=========================== catBlock ========================\n"+tmpl.render(page.getCurrentPath()+"/Category", true, page.getCurrentPath()+"/Category", Template.IF_DOESNT_EXIST_DO_NOTHING)+"\n==========================================================");-->
					tmpl.render(page.getCurrentPath()+"/Category", true, page.getCurrentPath()+"/Category", Template.IF_DOESNT_EXIST_DO_NOTHING);
				}
				if (hasSubCatSeparator) {
					tmpl.setVar(page.getCurrentPath()+"/CategorySeparator");
				}
				tmpl.setVar(page.getCurrentPath()+"/Category/Subcategory");
	
				if ( hasCatSeparator && model.getCategoryNumberInColumn() > 1 ) {
//System.out.println("CategorySeparator: "+model.getCategoryNumberInColumn());-->
					tmpl.render(page.getCurrentPath()+"/CategorySeparator", true, page.getCurrentPath()+"/Category", Template.IF_DOESNT_EXIST_DO_NOTHING);
				} else {
					if ( model.isNewColumn() && model.getCurrentCategoryNumber() > 1 ) {
						tmpl.render(page.getCurrentPath()+"/ColumnSeparator", true, page.getCurrentPath()+"/Category", Template.IF_DOESNT_EXIST_DO_NOTHING);
						tmpl.setVar(page.getCurrentPath()+"/NoCategories");
					}
				}
				model.fireBeforeShowCategoryEvent( new Event() );
				view.showControls(model, categoryControls, "/Category");
			}
			
			if (model.isShowSubCategory()) {
				page.setCurrentBlock("Category");
				if (hasSubCatSeparator) {
					if ( model.getCurrentSubCategoryNumber() > 1 ) {
						tmpl.render(page.getCurrentPath()+"/SubcategorySeparator", true, page.getCurrentPath()+"/Subcategory", Template.IF_DOESNT_EXIST_DO_NOTHING);
					} else {
						tmpl.setVar(page.getCurrentPath()+"/SubcategorySeparator");
					}
				}
				tmpl.setVar(page.getCurrentPath()+"/SubcategoriesTail");
				model.fireBeforeShowSubcategoryEvent( new Event() );
				view.showControls(model, subcategoryControls, "/Subcategory");
				tmpl.render(page.getCurrentPath()+"/Subcategory", true, page.getCurrentPath()+"/Subcategory", Template.IF_DOESNT_EXIST_DO_NOTHING);
				if ( model.isShowSubCategoryTail() ) {
					if (hasSubCatSeparator) {
						if ( model.getCurrentSubCategoryNumber() > 1 ) {
							tmpl.render(page.getCurrentPath()+"/SubcategorySeparator", true, page.getCurrentPath()+"/Subcategory", Template.IF_DOESNT_EXIST_DO_NOTHING);
						} else {
							tmpl.setVar(page.getCurrentPath()+"/SubcategorySeparator");
						}
					}
					view.showControls(model, subcattailControls, "/SubcategoriesTail");
					tmpl.render(page.getCurrentPath()+"/SubcategoriesTail", true, page.getCurrentPath()+"/Subcategory", Template.IF_DOESNT_EXIST_DO_NOTHING);
				}
				page.gotoParentBlock();
			} else {
				tmpl.setVar(page.getCurrentPath()+"/Subcategory");
				tmpl.setVar(page.getCurrentPath()+"/SubcategorySeparator");
			}
		}
		tmpl.setVar(page.getCurrentPath()+"/Category/SubcategoriesTail");
		tmpl.setVar(page.getCurrentPath()+"/Category/SubcategorySeparator");
		tmpl.render(page.getCurrentPath()+"/Category", true, page.getCurrentPath()+"/Category", Template.IF_DOESNT_EXIST_DO_NOTHING);
		page.gotoParentBlock();
	}
	
	public void show(EditableGrid model, Collection staticControls, Collection rowControls, 
			boolean hasSeparator, boolean hasClientScript) {
		
		if (staticControls==null) staticControls = new ArrayList();
		if (rowControls==null) rowControls = new ArrayList();

		page.setCurrentBlock("EditableGrid " + model.getName());
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}
		model.fireBeforeShowEvent( new Event() );
		if ( ! model.isVisible() ) {
			tmpl.setVar( page.getCurrentPath() );
			page.gotoParentBlock();
			return;
		}

		if (hasClientScript) {
			tmpl.setVar(page.getCurrentPath()+"/@FormScript", model.getFormScript());
		}

		for ( Iterator it = staticControls.iterator(); it.hasNext(); ) {
			com.codecharge.components.Model m = model.getChild((String) it.next());
			if ( m instanceof Control && ((Control) m).hasErrors() ) {
				model.addError(((Control) m).getErrorsAsString());
			} else if ( m instanceof VerifiableControl && ((VerifiableControl) m).hasErrors() && ((VerifiableControl) m).getErrorControlName() == null) {
				model.addError(((Control) m).getErrorsAsString());
			}
		}

		if ( model.hasErrors() ) {
			tmpl.setVar( page.getCurrentPath() + "/Error/@Error", model.getErrorsAsString(), Template.IF_DOESNT_EXIST_DO_NOTHING );
			tmpl.render( page.getCurrentPath() + "/Error", false, Template.IF_DOESNT_EXIST_DO_NOTHING );
		} else {
			tmpl.setVar( page.getCurrentPath() + "/Error" );
		}
		tmpl.setVar(page.getCurrentPath()+"/Row");
		if ( model.isEmpty() && (model.getNumberEmptyRows() == 0 || ! model.isAllowInsert())) {
			tmpl.render(page.getCurrentPath()+"/NoRecords", false, Template.IF_DOESNT_EXIST_DO_NOTHING);
		} else {
			tmpl.setVar(page.getCurrentPath()+"/NoRecords");
		}

		model.initializeRows();
		while ( model.hasNextRow() ) {
			HashMap row = model.nextRow();
			if (hasSeparator) {
				if ( row != null && model.getCurrentRowNumber() > 1 ) {
					tmpl.render(page.getCurrentPath()+"/Separator", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
				} else {
					tmpl.setVar(page.getCurrentPath()+"/Separator");
				}
			}
	
			ErrorCollection rowErrors = (ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY);
			if (rowErrors==null) {
				rowErrors = new ErrorCollection();
				row.put(Names.CCS_ROW_ERROR_KEY, rowErrors);
			}
			for ( Iterator it = model.getRowControls().iterator(); it.hasNext(); ) {
				Model m = model.getChild((String) it.next());
				if ( m instanceof Control && ((Control) m).hasErrors() ) {
					rowErrors.addError(((Control) m).getErrorsAsString());
				} else if ( m instanceof VerifiableControl && ((VerifiableControl) m).hasErrors() && ((VerifiableControl) m).getErrorControlName() == null) {
					rowErrors.addError(((Control) m).getErrorsAsString());
				}
			}
	
			if ( row != null && row.get(Names.CCS_ROW_ERROR_KEY) != null && ((ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY)).hasErrors() ) {
				tmpl.setVar(page.getCurrentPath()+"/Row/RowError");
				tmpl.setVar(page.getCurrentPath()+"/Row/RowError/@Error", ((ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY)).getErrorsAsString() );
				tmpl.render(page.getCurrentPath()+"/Row/RowError", Template.IF_DOESNT_EXIST_DO_NOTHING);
			} else {
				tmpl.setVar(page.getCurrentPath()+"/Row/RowError");
			}
	
			model.hideDeleteControl();
	
			model.fireBeforeShowRowEvent( new Event() );
	
			view.showControls(model, rowControls, "/Row", true, model.getCurrentRowNumber());
	
			tmpl.render(page.getCurrentPath()+"/Row", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);

		}



		if ( model.isAllowInsert() ) {
			int numEmptyRow = 0;

			while ( (! model.isProcessed()) && (numEmptyRow < model.getNumberEmptyRows()) ) {
				HashMap row = model.getEmptyRow();

				if (hasSeparator) {
					if ( numEmptyRow < model.getNumberEmptyRows() ) {
						tmpl.render(page.getCurrentPath()+"/Separator", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
					} else {
						tmpl.setVar(page.getCurrentPath()+"/Separator");
					}
				}
				numEmptyRow++;

				ErrorCollection rowErrors = (ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY);
				if (rowErrors==null) {
					rowErrors = new ErrorCollection();
					row.put(Names.CCS_ROW_ERROR_KEY, rowErrors);
				}
				for ( Iterator it = model.getRowControls().iterator(); it.hasNext(); ) {
					Model m = model.getChild((String) it.next());
					if ( m instanceof Control && ((Control) m).hasErrors() ) {
						rowErrors.addError(((Control) m).getErrorsAsString());
					} else if ( m instanceof VerifiableControl && ((VerifiableControl) m).hasErrors() && ((VerifiableControl) m).getErrorControlName() == null) {
						rowErrors.addError(((Control) m).getErrorsAsString());
					}
				}

				if ( model.hasRowErrors() ) {
					tmpl.setVar(page.getCurrentPath()+"/Row/RowError");
					tmpl.setVar(page.getCurrentPath()+"/Row/RowError/@Error", ((ErrorCollection) row.get(Names.CCS_ROW_ERROR_KEY)).getErrorsAsString() );
					tmpl.render(page.getCurrentPath()+"/Row/RowError", Template.IF_DOESNT_EXIST_DO_NOTHING);
				} else {
					tmpl.setVar(page.getCurrentPath()+"/Row/RowError");
				}

				model.hideDeleteControl();
						
				model.fireBeforeShowRowEvent( new Event() );

				view.showControls(model, rowControls, "/Row", true, model.getCurrentRowNumber());

				tmpl.render(page.getCurrentPath()+"/Row", true, page.getCurrentPath()+"/Row", Template.IF_DOESNT_EXIST_DO_NOTHING);
			}
		}

		model.nullChildRow();
    view.showControls(model, staticControls);

		StringBuffer formAction = new StringBuffer( page.getActionPageName() + ".do?ccsForm=" + model.getName() );
		HashMap parameters = new HashMap();
		if ((model.getPreserveType()==PreserveParameterType.POST || model.getPreserveType()==PreserveParameterType.ALL) && page.getHttpGetParameter("ccsForm")==null) {
			parameters.putAll(page.getHttpPostParams().getPreserveParameters( model.getExcludeParams() ));
		}
		Vector getExclude = new Vector();
		getExclude.add("ccsForm");
		parameters.putAll(page.getHttpGetParams().getPreserveParameters(getExclude));
		Iterator params = parameters.values().iterator();
		while(params.hasNext()) {
			formAction.append("&"+((String)params.next()));
		}

		tmpl.setVar(page.getCurrentPath()+"/Separator");
		tmpl.setVar(page.getCurrentPath()+"/@FormState", model.getFormState());
		tmpl.setVar( page.getCurrentPath() + "/@Action", SessionStorage.getInstance( page.getRequest() ).encodeURL(formAction.toString()) );
		tmpl.setVar( page.getCurrentPath() + "/@HTMLFormName", model.getName() );
		tmpl.setVar( page.getCurrentPath() + "/@HTMLFormEnctype", model.getFormEnctype() );
		tmpl.setVar( page.getCurrentPath() + "/@HTMLFormProperties", "method=\"POST\"" + 
				" action=\"" + SessionStorage.getInstance( page.getRequest() ).encodeURL(formAction.toString())+ 
				"\" name=\""+ model.getName() + "\"");
		if ( model.isVisible() ) {
			tmpl.render(page.getCurrentPath(), false);
		} else {
			tmpl.setVar(page.getCurrentPath() );
		}
		page.gotoParentBlock();
	}	
	
	public void showControls(Component model, Collection controls) {
		showControls(model, controls, null, false, 0);
	}
	
	public void showControls(Component model, Collection controls, String subBlockName) {
		showControls(model, controls, subBlockName, false, 0);
	}
	
	public void showControls(Component model, Collection controls, String subBlockName, boolean changeHtmlName, int index) {
		if (controls==null) return;
		for (Iterator it = controls.iterator(); it.hasNext(); ) {
			Model m = model.getChild((String) it.next());
			if (changeHtmlName) {
				m.setHtmlName(m.getName()+"_"+index);
			}
			show(subBlockName, m);
		}
	}
	
	public void init( HttpServletRequest req, HttpServletResponse resp, ServletContext context, Page page ) {
		this.req = req;
		this.resp = resp;
		this.context = context;
		this.view = this;
		if (! page.isIncluded()) this.resp.setContentType("text/html; charset=" + page.getCCSLocale().getCharacterEncoding());
		page.fireOnInitializeViewEvent(new Event());
		loadTemplate();
		page.setTemplate(getTemplate());
		page.fireBeforeShowEvent(new Event());
	}
}

//End View class

