package api

import (
	"github.com/gin-gonic/gin"
	"github.com/gogf/gf/frame/g"
	"github.com/gogf/gf/util/gconv"
	"net/http"
	Biz "simple/internal/biz"
	"simple/internal/foundation/app"
	"simple/internal/req"
)

//simple控制器等
type User struct {
}

type EditUserBizRule struct {
	Title string
}

type CreateUserBizRule struct {
	Title string
}

func (user User) List(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	num := ctx.DefaultQuery("num", "0")
	service := Biz.UserBiz{}
	resp.Data = service.List(gconv.Int(num))
	resp.End(ctx)
	return
}

func (user User) Info(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	id := ctx.Param("id")
	biz := Biz.UserBiz{}
	var err error
	if resp.Data, err = biz.Info(gconv.Int(id)); err != nil {
		resp.Code = http.StatusBadRequest
		resp.Message = err.Error()
		resp.End(ctx)
		return
	}
	resp.End(ctx)
	return
}

func (user User) Create(ctx *gin.Context) {
	resp := app.NewResponse(http.StatusOK, nil, "")
	//请求参数校验
	bizRule := EditUserBizRule{}
	//参数绑定 修改时候的参数和更新时候的参数。
	bizReq := req.CreateUser{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp.Code = http.StatusBadRequest
		resp.Message = err.Error()
		resp.End(ctx)
		return
	}
	biz := Biz.UserBiz{}
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

func (user User) Edit(ctx *gin.Context) {
	//参数绑定
	resp := app.NewResponse(http.StatusOK, nil, "")
	bizRule := EditUserBizRule{}
	bizReq := req.EditUser{}
	if err := app.ValidatorRules(ctx, gconv.Map(bizRule), &bizReq); err != nil {
		resp.Code = http.StatusBadRequest
		resp.Message = err.Error()
		resp.End(ctx)
		return
	}
	id := ctx.Param("id")
	biz := Biz.UserBiz{}
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

func (user User) Delete(ctx *gin.Context) {
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
	biz := Biz.UserBiz{}
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
