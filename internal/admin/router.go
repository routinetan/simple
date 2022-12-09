package admin

import (
	"fmt"
	"github.com/gin-gonic/gin"
	jsoniter "github.com/json-iterator/go"
	"html/template"
	"net/http"
	"os"
	"simple/foundation/app"
	"simple/foundation/middlewares"
	"simple/foundation/rbac"
	"simple/foundation/server"
	"simple/foundation/util"
	"simple/internal/admin/controller"
)

func GetRouter(engine *gin.Engine) {
	engine.LoadHTMLFiles()
	// 注册自定义函数
	engine.SetFuncMap(template.FuncMap{
		"map": func(json string) gin.H {
			var out gin.H
			_ = jsoniter.UnmarshalFromString(json, &out)
			return out
		},
	})

	// 加载模板
	//engine.LoadHTMLGlob("web/admin/dist/*")
	engine.StaticFS("/assets", http.Dir("./web/admin/dist/assets/"))
	engine.StaticFS("/css", http.Dir("./web/admin/dist/css/"))
	engine.StaticFS("/js", http.Dir("./web/admin/dist/js/"))
	engine.StaticFS("/public", http.Dir("./public"))
	// 注册公用的中间件

	//业务逻辑代码-开始
	engine.Use(middlewares.CORS)
	engine.GET("/simples", controller.Simple{}.List)
	engine.GET("/simple/:id", controller.Simple{}.Info)
	engine.POST("/simple/:id", controller.Simple{}.Create)
	engine.POST("/simple/:id", controller.Simple{}.Edit)
	engine.DELETE("/simple/:id", controller.Simple{}.Delete)
	//业务逻辑代码-结束

	// 登录路由需要在jwt验证中间件之前

	// 注册一个权限验证的中间件
	//engine.Use(managerMiddleWares.CheckPermission)

	// 注册一个公共上传接口
	if !util.Exists("./public/wx") {
		os.MkdirAll("./public/wx", 0777)
	}
	var saveHandler = new(app.DefaultSaveHandler).SetPrefix(fmt.Sprintf("%s://%s", server.Config.Schema, server.Config.Domain))
	saveHandler.SetPublicDst("/public/wx/").SetDst("./public/wx/")
	engine.POST("/upload", app.Upload("file", saveHandler, "png", "jpg"))

	// CSRFtoken支持, 因为 upload 不需要受 CSRFtoken 限制, 故将上传接口放在了上边
	//engine.Use(middlewares.CsrfToken)

	// 将权限验证数据表的CURD接口进行注册
	rbac.Inject(engine)
}
