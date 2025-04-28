<%@ page contentType="${contentType}" %>
<%@ page import="java.io.*" %>
<%
    
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    
    response.setHeader("Content-Disposition", pageContext.findAttribute("contentDisposition"));
    
    byte[] data = (byte[]) request.getAttribute("binaryData");
    try (OutputStream output = response.getOutputStream()) {
        output.write(data);
    } catch (IOException e) {
        throw new RuntimeException("Erreur d'écriture du PDF", e);
    }
%>