package rest

import (
	"context"
	"io"
	"net/http"
	"strings"

	logger "log"

	"github.com/coreos/go-oidc"
	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
)

var authContext = context.TODO()

var provider, provider_err = oidc.NewProvider(authContext, "EDIT ME SETTING TENANT ISSUER")

var oauthConf oauth2.Config
var idTokenVerifier *oidc.IDTokenVerifier

var GRAPH_API_ME = "https://graph.microsoft.com/v1.0/me"

func init() {
	if provider_err == nil {
		oauthConf = oauth2.Config{

			ClientID:     "EDIT ME",
			ClientSecret: "EDIT ME",
			RedirectURL:  "http://localhost:8080/api/auth",
			Endpoint: oauth2.Endpoint{
				TokenURL: "https://login.microsoftonline.com/organizations/oauth2/v2.0/token",
				AuthURL:  "https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize",
			},
		}

		idTokenVerifier = provider.Verifier(&oidc.Config{
			ClientID:             oauthConf.ClientID,
			SupportedSigningAlgs: []string{"RS256"},
			SkipIssuerCheck:      true,
			SkipClientIDCheck:    true,
		})
	} else {
		logger.Fatalf("Provider creation error: %v", provider_err)
	}
}
func handleOAuth2Callback(c *gin.Context) {

	// w := c.Writer

	code := c.Query("code")
	logger.Println("Received Code>> " + code)

	token, err := oauthConf.Exchange(c, code)
	if err != nil {
		logger.Println("oauthConf.Exchange() failed with " + err.Error() + "\n")
		return
	}
	logger.Println("handleOAuth2Callback >> AccessToken >> " + token.AccessToken)

	// tokenjson, err := json.Marshal(token)

	if err != nil {
		logger.Println("Error in Marshalling the token")
		c.AbortWithStatus(500)
	}

	req, err := http.NewRequest("GET", GRAPH_API_ME, nil)

	client := &http.Client{}
	req.Header.Add("Authorization", "Bearer "+string(token.AccessToken))
	res, err := client.Do(req)

	body, err := io.ReadAll(res.Body)
	res.Body.Close()

	userdata := string(body)
	logger.Println("handleOAuth2Callback >> User >>" + userdata)

	c.Redirect(302, "http://localhost:3000/loginConfirm?token="+token.AccessToken)
	// w.Header().Set("Content-Type", "application/json; charset=utf-8")
	// w.WriteHeader(http.StatusOK)
	// w.Write(tokenjson)
}

func Authorizer(c *gin.Context) {
	logger.Println("=== Authorizer Middleware")
	authHeader := c.Request.Header.Get("Authorization")
	if authHeader != "" {
		rawToken := strings.Replace(authHeader, "Bearer ", "", 1)
		req, err := http.NewRequest("GET", GRAPH_API_ME, nil)
		if err == nil {
			client := &http.Client{}
			req.Header.Add("Authorization", "Bearer "+string(rawToken))
			res, err := client.Do(req)

			if err == nil {
				if res.StatusCode == http.StatusOK {
					body, err := io.ReadAll(res.Body)
					res.Body.Close()
					if err == nil {
						c.Set("user", string(body))
					}
					logger.Println("Authorizer >> User >> " + c.GetString("user"))

					c.Next()
					return
				}
			}
			logger.Printf("Invalid bearer token: %v", res.Status)
			c.AbortWithStatusJSON(http.StatusUnauthorized, "Invalid Bearer token")
			return
		}
		logger.Printf("Http request error: %v", err)
		c.AbortWithStatusJSON(http.StatusInternalServerError, "Graph API communication error")

		// === CODE TO USE VERIFY ACCESS TOKEN (DID NOT WORK)
		// idToken, err := idTokenVerifier.Verify(c, rawToken)
		// if err == nil {
		// 	if err := idToken.VerifyAccessToken(rawToken); err == nil {
		// 		logger.Printf("Valid bearer token")
		// 		c.Next()
		// 		return
		// 	}
		// }
		// logger.Printf("Invalid bearer token: %v", err)
		// c.AbortWithStatusJSON(http.StatusUnauthorized, "Invalid Bearer token")
		// return
	}
	c.AbortWithStatusJSON(http.StatusBadRequest, map[string]string{"error": "Authorization header was not identified"})
}

type AuthHeader struct {
	access_token string `header:"Authorization"`
}
