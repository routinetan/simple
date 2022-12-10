package biz

import (
	"errors"
	"github.com/gogf/gf/frame/g"
	"github.com/gogf/gf/util/gconv"
	"gorm.io/gorm"
	"simple/internal/foundation/app"
	"simple/internal/foundation/database/orm"
	"simple/internal/foundation/paginator"
	"simple/internal/req"
	"simple/internal/store"
)

type UserBiz struct {
}

func (userBiz *UserBiz) List(num int) g.Map {
	var users []store.User
	var countRows int
	orm.Master().Find(&users).Count(&countRows)
	p := paginator.NewPagintor(0, countRows)
	orm.Master().Table("users").Offset(num).Limit(p.Rows).Find(&users)
	rownum := countRows / p.Rows
	return g.Map{"rownum": rownum + 1, "rows": len(users), "data": users}
}

func (userBiz *UserBiz) Info(id int) (g.Map, error) {
	userId := gconv.Int(id)
	user := store.User{}
	err := orm.Master().Table("users").First(&user, "id = ?", userId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Warn(err)
		return nil, errors.New("记录不存在")
	}
	return gconv.Map(user), nil
}

func (userBiz *UserBiz) Create(req req.CreateUser) (g.Map, error) {
	user := store.User{}
	//检查条件
	//err := orm.Master().First(&, "title = ?", userId).Error
	//if err == gorm.ErrRecordNotFound {
	//	app.Logger().Error(err)
	//	return nil, errors.New("数据未找到")
	//}
	//保存
	query := orm.Master().Table("users").Save(&user)
	rows := query.RowsAffected
	err := query.Error
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, err
	}
	return gconv.Map(user), nil
}

func (userBiz *UserBiz) Edit(id int, req req.EditUser) (g.Map, error) {
	userId := gconv.Int(id)
	user := store.User{}
	err := orm.Master().First(&user, "id = ?", userId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("users").Where("id = ?", id).Updates(&user)
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("保存失败")
	}
	return gconv.Map(user), nil
}

func (userBiz *UserBiz) Delete(id int) (g.Map, error) {
	userId := gconv.Int(id)
	user := store.User{}
	err := orm.Master().Table("user").First(&user, "id = ?", userId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("users").Delete(&user)
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("系统错误")
	}
	return nil, nil
}
