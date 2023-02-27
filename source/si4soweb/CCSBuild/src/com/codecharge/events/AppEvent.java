//AppEvent @0-337E1E50
package com.codecharge.events;

import javax.servlet.*;

public class AppEvent {

    ServletConfig conf;

    public AppEvent( ServletConfig conf ) {
        this.conf = conf;
    }

    public ServletConfig getServletConfig() {
        return conf;
    }

}
//End AppEvent

