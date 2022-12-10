package controller

import (
	"github.com/gin-gonic/gin"
    "github.com/gogf/gf/frame/g"
    "github.com/gogf/gf/util/gconv"
    "simple/internal/foundation/app"
    "simple/internal/req"
    "net/http"
    Biz "simple/internal/biz"
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
    resp := app.NewResponse(http.StatusOK, nil, "")
	num := ctx.DefaultQuery("num", "0")
	service := Biz.{{.CStruct}}Biz{}
	resp.Data = service.List(gconv.Int(num))
    resp.End(ctx)
    return
}

func ({{.CVal}} {{.CStruct}}) Info(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	id := ctx.Param("id")
	biz := Biz.{{.CStruct}}Biz{}
	var err error
	if resp.Data,err = biz.Info(gconv.Int(id)); err != nil {
		resp.Code = http.StatusBadRequest
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
    resp.End(ctx)
    return
}

func ({{.CVal}} {{.CStruct}}) Create(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	//请求参数校验
	bizRule := Edit{{.CStruct}}BizRule{}
	//参数绑定 修改时候的参数和更新时候的参数。
	bizReq := req.Create{{.CStruct}}{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp.Code = http.StatusBadRequest
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	biz := Biz.{{.CStruct}}Biz{}
	var err error
	if resp.Data, err = biz.Create(bizReq); err != nil {
		resp.Code = http.StatusInternalServerError
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	resp.End(ctx)
    return
}

func ({{.CVal}} {{.CStruct}}) Edit(ctx *gin.Context) {
	//参数绑定
	resp := app.NewResponse(http.StatusOK, nil, "")
	bizRule := Edit{{.CStruct}}BizRule{}
	bizReq := req.Edit{{.CStruct}}{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp.Code = http.StatusBadRequest
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	id := ctx.Param("id")
	biz := Biz.{{.CStruct}}Biz{}
	var err error
	if resp.Data, err = biz.Edit(gconv.Int(id), bizReq); err != nil {
		resp.Code = http.StatusInternalServerError
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	resp.End(ctx)
    return
}

func ({{.CVal}} {{.CStruct}}) Delete(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	//请求参数校验
	id := ctx.Param("id")
	bizRule := map[string]string{}
	//参数绑定 修改时候的参数和更新时候的参数。
	bizReq := g.Map{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp.Code = http.StatusBadRequest
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	biz := Biz.{{.CStruct}}Biz{}
	var err error
	if resp.Data, err = biz.Delete(gconv.Int(id)); err != nil {
		resp.Code = http.StatusInternalServerError
        resp.Message = err.Error()
        resp.End(ctx)
        return
	}
	resp.End(ctx)
    return
}
