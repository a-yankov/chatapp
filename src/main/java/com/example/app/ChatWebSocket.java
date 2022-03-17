package com.example.app;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;


@ServerEndpoint("/chat-endpoint")
public class ChatWebSocket {
    private static Set<Session> sessions = new HashSet<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket opened: " + session.getId());
        sessions.add(session);
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("message received: " + message + " from " + session.getId());
        try {
            for (Session s: sessions) {
                s.getBasicRemote().sendObject(message);
            }
            //session.getBasicRemote().sendObject(message);
        } catch (IOException | EncodeException e) {
            e.printStackTrace();
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.out.println("WebSocket error for " + session.getId() + " " + throwable.getMessage());
    }

    @OnClose
    public void onClose(Session session, CloseReason closeReason) {
        System.out.println("WebSocket closed for " + session.getId()
                + " with reason " + closeReason.getCloseCode());
        sessions.remove(session);
    }
}
