package org.intalio.tempo.security.ws;

import static org.intalio.tempo.security.ws.Constants.TOKEN_NS;

import javax.xml.namespace.QName;

public class TokenConstants {

    public static final QName AUTHENTICATE_USER = new QName(TOKEN_NS.getNamespaceURI(), "authenticateUser");

    public static final QName AUTHENTICATE_USER_WITH_CREDENTIALS =
            new QName(TOKEN_NS.getNamespaceURI(), "authenticateUserWithCredentials");

    public static final QName AUTHENTICATE_USER_RESPONSE =
            new QName(TOKEN_NS.getNamespaceURI(), "authenticateUserResponse");

    public static final QName GET_TOKEN_PROPERTIES = new QName(TOKEN_NS.getNamespaceURI(), "getTokenProperties");

    public static final QName GET_TOKEN_PROPERTIES_RESPONSE =
            new QName(TOKEN_NS.getNamespaceURI(), "getTokenPropertiesResponse");

    public static final QName USER = new QName(TOKEN_NS.getNamespaceURI(), "user");

    public static final QName PASSWORD = new QName(TOKEN_NS.getNamespaceURI(), "password");

    public static final QName CREDENTIALS = new QName(TOKEN_NS.getNamespaceURI(), "credentials");

    public static final QName TOKEN = new QName(TOKEN_NS.getNamespaceURI(), "token");

}