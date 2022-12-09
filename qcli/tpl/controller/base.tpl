package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/gogf/gf/frame/g"
	"github.com/gogf/gf/util/gconv"
	"github.com/json-iterator/go/extra"
	"simple/foundation/app"
	"simple/internal/req"
	"simple/internal/service"
)

//simple控制器等
type {{.CStruct}} struct {
}

type Edit{{.CStruct}}BizRule struct {
	Title string
}

type Create{{.CStruct}}BizRule struct {
	Title string
}

func ({{.CVal}} {{.CStruct}}) List(ctx *gin.Context) {
	num := ctx.DefaultQuery("num", "0")
	service := service.{{.CStruct}}Service{}
	resp := service.List(gconv.Int(num))
	extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
	ctx.PureJSON(200, resp)
}

func ({{.CVal}} {{.CStruct}}) Info(ctx *gin.Context) {
	resp := g.Map{}
	resp["code"] = 200
	resp["msg"] = ""
	id := ctx.Param("id")
	service := service.{{.CStruct}}Service{}
	var err error
	if resp, err = service.Info(gconv.Int(id)); err != nil {
		resp["code"] = 400
		resp["msg"] = err.Error()
		ctx.PureJSON(200, resp)
		return
	}
	extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
	ctx.PureJSON(200, resp)
}

func ({{.CVal}} {{.CStruct}}) Create(ctx *gin.Context) {
	resp := g.Map{}
	//请求参数校验
	bizRule := Edit{{.CStruct}}BizRule{}
	//参数绑定 修改时候的参数和更新时候的参数。
	bizReq := req.Create{{.CStruct}}{}
	if verr := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); verr != nil {
		resp["code"] = 400
		resp["msg"] = verr.Error()
		ctx.PureJSON(200, resp)
		return
	}
	service := service.{{.CStruct}}Service{}
	var err error
	if resp, err = service.Create(bizReq); err != nil {
		resp["code"] = 400
		resp["msg"] = err.Error()
		ctx.PureJSON(200, resp)
		return
	}
	extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
	ctx.PureJSON(200, resp)
}

func ({{.CVal}} {{.CStruct}}) Edit(ctx *gin.Context) {
	//参数绑定
	resp := g.Map{}
	bizRule := Edit{{.CStruct}}BizRule{}
	bizReq := req.Edit{{.CStruct}}{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp["code"] = 400
		resp["msg"] = err.Error()
		ctx.PureJSON(200, resp)
		return
	}
	id := ctx.Param("id")
	service := service.{{.CStruct}}Service{}
	var err error
	if resp, err = service.Edit(gconv.Int(id), bizReq); err != nil {
		resp["code"] = 400
		resp["msg"] = err.Error()
		ctx.PureJSON(200, resp)
		return
	}
	ctx.Status(200)
	extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
	ctx.PureJSON(200, resp)
}

func ({{.CVal}} {{.CStruct}}) Delete(ctx *gin.Context) {
	resp := g.Map{}
	//请求参数校验
	id := ctx.Param("id")
	bizRule := map[string]string{}
	//参数绑定 修改时候的参数和更新时候的参数。
	bizReq := g.Map{}
	verr := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq)
	if verr != nil {
		resp["code"] = 400
		resp["msg"] = verr.Error()
		ctx.PureJSON(200, resp)
		return
	}
	service := service.{{.CStruct}}Service{}
	var err error
	if resp, err = service.Delete(gconv.Int(id)); err != nil {
		resp["code"] = 400
		resp["msg"] = err.Error()
		ctx.PureJSON(200, resp)
		return
	}
	extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
	ctx.PureJSON(200, resp)
}
