package rest

import (
	"net/http"

	"github.com/RelationalAI/sales-engineering/common/rest-api-go/database"
	"github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
)

func Run() {
	// router := gin.Default()
	router := gin.New()

	router.Use(static.Serve("/", static.LocalFile("./static", true)))

	router.GET("/api/auth", handleOAuth2Callback)

	restricted := router.Group("/api/restrict")

	restricted.Use(CorsConfig())
	restricted.Use(Authorizer)

	restricted.OPTIONS("/user/me", func(ctx *gin.Context) { ctx.Request.Response.StatusCode = 200 })
	restricted.GET("/user/me", userMeGET)

	restricted.OPTIONS("/sample", func(ctx *gin.Context) { ctx.Request.Response.StatusCode = 200 })
	restricted.GET("/sample", raiSampleGET)

	router.GET("/api/sample", raiSampleGET)

	router.Run()
}

func raiSampleGET(c *gin.Context) {

	res, _ := database.Execute(`
		def gosample:nodes = ("1", "John", "pilot");("2","1000", "flight"); ("3", "Anne", "passenger")
		def gosample:nodes = ("4", "Grace", "pilot");("5","2000", "flight"); ("6", "Peter", "passenger")
		def gosample:edges = ("1","2");("3","2")
		def gosample:edges = ("4","5");("6","5")

		def output:edge = gosample:edges
		def output:node = gosample:nodes
	`)

	c.IndentedJSON(http.StatusOK, res)
}
