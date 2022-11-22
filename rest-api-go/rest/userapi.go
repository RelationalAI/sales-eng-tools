package rest

import (
	logger "log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func userMeGET(c *gin.Context) {
	logger.Println("userMeGET >> User >> " + c.GetString("user"))

	w := c.Writer
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(c.GetString("user")))
}
