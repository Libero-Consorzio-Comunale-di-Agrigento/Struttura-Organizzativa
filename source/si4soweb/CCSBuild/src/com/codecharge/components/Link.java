//Link component @0-DC44D5F4
package com.codecharge.components;

import com.codecharge.util.*;
import com.codecharge.db.*;
import java.util.*;

/**
  Link represents an anchor tag from html.
  It allows to dynamically calculate href attribute and the Link caption itself.
  It also can transfer parameters from GET and/or POST to url it refers to.
**/
public class Link extends Control {

    public final static int PRESERVE_NONE = 0;
    public final static int PRESERVE_GET = 1;
    public final static int PRESERVE_POST = 2;
    public final static int PRESERVE_ALL = 3;

    /** Which parameters to preserve NONE, POST, GET, ALL. **/
    protected PreserveParameterType preserveType;
    /** Type of the hrefSource Database or Page. **/
    protected String hrefType;
    /** Page name or column name from which url is formed. **/
    protected String hrefSource;
    /** URL calculated from hrefSource and hrefType that will be used in Link aref attribute. **/
    protected String hrefSourceValue;
    /** Convert to absolute or https url. **/
    protected String convertRule;
    /** URL parameters of the Link. This is the Collection of LinkParameters. **/
    protected Vector parameters = new Vector();

    protected String hrefSourcePrefix;

    public Link(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
        addExcludeParam("ccsForm");
    }

    public Link(String name, Page page) {
        super(name, page);
        addExcludeParam("ccsForm");
    }

    public int getPreserveType() {
        int type = Link.PRESERVE_NONE;
        if ( preserveType == PreserveParameterType.ALL ) {
            type = Link.PRESERVE_ALL;
        } else if ( preserveType == PreserveParameterType.GET ) {
            type = Link.PRESERVE_GET;
        } else if ( preserveType == PreserveParameterType.POST ) {
            type = Link.PRESERVE_POST;
        }
        return type;
    }

    public void setPreserveType( int type ) {
        if ( type == Link.PRESERVE_ALL ) {
            preserveType = PreserveParameterType.ALL;
        } else if ( type == Link.PRESERVE_GET ) {
            preserveType = PreserveParameterType.GET;
        } else if ( type == Link.PRESERVE_POST ) {
            preserveType = PreserveParameterType.POST;
        } else if ( type == Link.PRESERVE_NONE ) {
            preserveType = PreserveParameterType.NONE;
        }
    }

    public void setPreserveType( PreserveParameterType type ) {
        preserveType = type;
    }

/*    public void setHrefSource( String hrefSource ) {
      this.hrefSourceValue = hrefSource; //TODO: Synchronize with JSP version
    }

    public void setHrefSource( int hrefSource ) {
      this.hrefSourceValue = String.valueOf( hrefSource );
    }

    public void setHrefSource( long hrefSource ) {
      this.hrefSourceValue = String.valueOf( hrefSource );
    }

    public void setHrefSource( boolean hrefSource ) {
      this.hrefSourceValue = String.valueOf( hrefSource );
    }
*/
    public String getHrefSourceValue() {
        return (hrefSourceValue == null ? "" : hrefSourceValue);
    }

    public void setHrefSourceValue( String hrefSource ) {
        this.hrefSourceValue = hrefSource;
    }

    public void setHrefSourceValue( Object hrefSource ) {
        if ( hrefSource == null ) {
            this.hrefSourceValue = null;
        } else {
            this.hrefSourceValue = hrefSource.toString();
        }
    }

    public void setHrefSourceValue( long hrefSource ) {
        this.hrefSourceValue = String.valueOf(hrefSource);
    }

    public void setHrefSourceValue( double hrefSource ) {
        this.hrefSourceValue = String.valueOf(hrefSource);
    }

    public void setHrefSourceValue( boolean hrefSource ) {
        this.hrefSourceValue = String.valueOf(hrefSource);
    }

    public String getHrefSource() {
      return hrefSource;
    }
    public void setHrefSource(String source) {
      this.hrefSource = source;
    }

    public void setHrefSourcePrefix( String hrefSourcePrefix ) {
      this.hrefSourcePrefix = hrefSourcePrefix;
    }

    public void addHrefParameters( String params ) {
      if ( StringUtils.isEmpty( params ) ) return;
      StringTokenizer st = new StringTokenizer( params, "&" );
      while ( st.hasMoreTokens() ) {
        String token = st.nextToken();
        String name = token;
        String value = "";
        int pos = token.indexOf( "=" );
        if ( pos > -1 ) {
          value = token.substring( pos + 1 );
          name = token.substring( 0, pos );
        }
        LinkParameter param = new LinkParameter(name, null, ParameterSource.CONST);
        param.setValue(value);
        parameters.add(param);
      }
    }

    /** Remove all url parameters. **/
    public void clearParameters() {
      parameters.clear();
    }

    /** Add LinkParameter to parameters Collection.
      @param param link parameter */
    public void addParameter(LinkParameter param) {parameters.add(param);}

    /** Return Collection of LinkParameters. **/
    public Collection getParameters() {return parameters;}
    public void setParameters(Vector params) {this.parameters = params;}

    /** Find LinkParameter in parameters collection by its name.
      @param name parameter name */
    public LinkParameter getParameter(String name) {
      for (int i=0; i < parameters.size(); i++) {
        LinkParameter p = (LinkParameter)parameters.get(i);
        if (p.getName().equals(name)) return p;
      }
      return null;
    }

    /** Convert to absolute or https url. **/
    public void setConvertRule(String rule) {convertRule = rule;}

    /** From where to get url hrefSource or DataBase. **/
    public void setHrefType(String type) {hrefType = type;}
    public String getHrefType() {return hrefType;}

    /** Calculate url for the Link.
        Never returns null.
    **/
    public String getHref() {
      StringBuffer href = new StringBuffer();
      StringBuffer params = new StringBuffer();
      String prefix = null;
      String hrefVal = hrefSourceValue;
      if ("Database".equals(hrefType) && StringUtils.isEmpty(hrefVal)) return "";
      //TODO: hrefSourcePrefix
      if ( hrefSourcePrefix != null ) {
        prefix = hrefSourcePrefix;
      } else {
          if ( "Absolute".equalsIgnoreCase( convertRule ) ) {
          	prefix = (String) ContextStorage.getInstance().getAttribute("serverUrl");
          	if (! prefix.endsWith("/")) {
				prefix = prefix + "/";
          	}
          } else if ( "SSL".equalsIgnoreCase( convertRule ) ) {
            prefix = (String) ContextStorage.getInstance().getAttribute("securedUrl");
			if (! prefix.endsWith("/")) {
				prefix = prefix + "/";
			}
          } else { 
            if ( prefix != null ) prefix += "/";
            if (page.isIncluded()) {
                hrefVal = getRelativePath();
            }
          }
      }
      if (prefix != null) href.append(prefix);
      if (hrefVal != null) href.append(hrefVal);
      HashMap linkParams = getPreserveParameters();
      for (Iterator i = parameters.iterator(); i.hasNext(); ) {
        LinkParameter param = (LinkParameter)i.next();
        String paramString = param.toString();
        if (! StringUtils.isEmpty(paramString)) {
			linkParams.put(param.getName(), paramString);
        }
      }
      if ( linkParams.size() > 0 ) {
        href.append("?");
      }
      for (Iterator i = linkParams.keySet().iterator(); i.hasNext(); ) {
        href.append((String) linkParams.get(i.next()));
        if ( i.hasNext() ) {
			href.append("&");
        }
      }
      return href.toString();
    }

    /** Get String of paremeters this Link should preserve in query string format. **/
    public HashMap getPreserveParameters() {
        HashMap result = new HashMap();
        if ( preserveType == PreserveParameterType.POST || preserveType == PreserveParameterType.ALL ) {
            result.putAll(page.getHttpPostParams().getPreserveParameters( excludeParams ));
        }
		if ( preserveType == PreserveParameterType.GET || preserveType == PreserveParameterType.ALL ) {
			result.putAll(page.getHttpGetParams().getPreserveParameters( excludeParams ));
		}
        return result;
    }

    protected String toHtml( String value ) {
      if ( isHtmlEncode() ) {
         value = StringUtils.toHtml( value );
         value = StringUtils.replace( value, "\r", "" );
         value = StringUtils.replace( value, "\n", "<br>" );
         //value = StringUtils.replace( value, "  ", " &nbsp;" );
      }
      return value;
    }

    private void toParameters( String str ) {
      if ( StringUtils.isEmpty( str ) ) return;
      StringTokenizer st = new StringTokenizer( str, "&" );
      while ( st.hasMoreTokens() ) {
        String token = st.nextToken();
        String name = token;
        String value = "";
        int pos = token.indexOf( "=" );
        if ( pos > -1 ) {
          value = token.substring( pos + 1 );
          name = token.substring( 0, pos );
        }
        parameters.add( new LinkParameter( name, value, ParameterSource.CONST ) );
      }
    }

    public Object clone() {
      Link obj = null;
      obj = (Link)super.clone();
      Vector params = new Vector(parameters);
      for (int i = 0; i<params.size(); i++) {
        params.set(i, ((LinkParameter)params.get(i)).clone());
      }
      obj.setParameters(params);
      return obj;
    }

    private String getRelativePath() {
        if (StringUtils.isEmpty(hrefSourceValue)) return "";
        String result = null;
        java.util.List listValue = StringUtils.splitToList(hrefSourceValue,'/','\\');
        java.util.List listPath = StringUtils.splitToList(page.getRequest().getServletPath(),'/','\\');
        String valuePage = "";
		if (listValue.size()>0) valuePage = (String) listValue.get(listValue.size()-1);
		if (listValue.size()>0) listValue.remove(listValue.size()-1);
        if (listValue.size()>0) {listValue.remove(0);}
        if (listPath.size()>0) {listPath.remove(0);}
        if (listPath.size()>0) {listPath.remove(listPath.size()-1);}

        java.util.List first = listValue.size() <= listPath.size() ? listValue: listPath;
        java.util.List second = listValue.size() > listPath.size() ? listValue: listPath;
        for (int i =0; i < first.size(); i++ ) {
            if (first.get(i).equals(second.get(i))) {
                first.remove(i);
                second.remove(i);
                i--;
            } else {
                break;
            }
        }

        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < listPath.size(); i++ ) {
            sb.append("../");
        }
        for (int i = 0; i < listValue.size(); i++ ) {
            if (! StringUtils.isEmpty((String) listValue.get(i))) {
                sb.append(listValue.get(i)+"/");
            }
        }
        sb.append(valuePage);
        result = sb.toString();
        return result;
    }
}
//End Link component

