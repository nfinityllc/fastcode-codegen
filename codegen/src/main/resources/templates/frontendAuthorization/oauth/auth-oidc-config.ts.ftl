import { AuthConfig } from 'angular-oauth2-oidc';

    export const AuthOidcConfig: AuthConfig = {
      // Url of the Identity Provider
      issuer:'https://nfinityllc-usman.okta.com/oauth2/default', //'http://localhost:4400/oidc/oauth2/default',   // 'https://dev-568072.okta.com/oauth2/default', // 'https://demo.identityserver.io',
      tokenEndpoint: 'https://nfinityllc-usman.okta.com/oauth2/default/v1/token',
      // URL of the SPA to redirect the user to after login
      redirectUri:'https://localhost:4400/callback', //window.location.origin, // window.location.origin + '/index.html',
      postLogoutRedirectUri:'https://localhost:4400',
      // The SPA's id. The SPA is registerd with this id at the auth-server
      // clientId: 'server.code',
      clientId: '0oa1dpe6xa5SKvHR0357',

      // Just needed if your auth server demands a secret. In general, this
      // is a sign that the auth server is not configured with SPAs in mind
      // and it might not enforce further best practices vital for security
      // such applications.
      // dummyClientSecret: 'secret',

      responseType: 'code',

      // set the scope for the permissions the client should request
      // The first four are defined by OIDC. 
      // Important: Request offline_access to get a refresh token
      // The api scope is a usecase specific one
      scope: 'openid profile email', //'api://default',

      showDebugInformation: true,
      requireHttps:false

      // Not recommented:
      // disablePKCI: true,
    };

    /*"/oidc": {
      "target": "https://dev-568072.okta.com",
      "secure": false,         
      "pathRewrite": {
        "^/oidc": ""
      },  
      "changeOrigin":true
    }*/