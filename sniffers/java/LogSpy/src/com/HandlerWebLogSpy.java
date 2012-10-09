/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.websocket.WebSocket;
import org.eclipse.jetty.websocket.WebSocketHandler;

/**
 *
 * @author inguanzo
 */
public class HandlerWebLogSpy extends WebSocketHandler {

    public WebSocket doWebSocketConnect(HttpServletRequest request,
            String protocol) {
        return new SpyWebSocket();
    }

    private class SpyWebSocket implements WebSocket.OnTextMessage {

        private Connection connection;

        public void onOpen(Connection connection) {
            this.connection = connection;
            try {
                connection.sendMessage("test");
            } catch (IOException ex) {
                Logger.getLogger(HandlerWebLogSpy.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        public void onMessage(String data) {
            System.out.println(data);
        }

        public void onClose(int closeCode, String message) {
            connection = null;
        }
    }
}
