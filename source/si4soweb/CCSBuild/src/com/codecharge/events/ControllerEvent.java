//ControllerEvent @0-6701080B
package com.codecharge.events;

import javax.servlet.*;
import javax.servlet.http.*;

public class ControllerEvent {

    ServletContext context;
    HttpServletRequest request;
    HttpServletResponse response;

    public ControllerEvent( ServletContext context, HttpServletRequest request, HttpServletResponse response ) {
        this.context = context;
        this.request = request;
        this.response = response;
    }

    public ServletContext getServletContext() {
        return context;
    }

    public HttpServletRequest getHttpServletRequest() {
        return request;
    }

    public HttpServletResponse getHttpServletResponse() {
        return response;
    }

}
//End ControllerEvent

