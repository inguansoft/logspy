package com;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.DefaultHandler;

/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
/**
 *
 * @author inguanzo
 */
public class LogSpy {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            Server server = new Server(3003);
            server.setHandler(new HandlerWebLogSpy());

            HandlerWebLogSpy webSocketHandler = new HandlerWebLogSpy();
            webSocketHandler.setHandler(new DefaultHandler());
            server.setHandler(webSocketHandler);

            server.start();
            server.join();
        } catch (Throwable e) {
            e.printStackTrace();
        }

    }
}
