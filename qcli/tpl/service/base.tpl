package service

import (
	"errors"
	"github.com/gogf/gf/frame/g"
	"github.com/gogf/gf/util/gconv"
	"gorm.io/gorm"
	"simple/foundation/app"
	"simple/foundation/database/orm"
	"simple/foundation/paginator"
	"simple/internal/model"
	"simple/internal/req"
)

type {{.CStruct}}Service struct {
}

func ({{.Model}}Service *{{.CStruct}}Service) List(num int) g.Map {
	var {{.Model}}s []model.{{.CStruct}}
	var countRows int
	orm.Master().Find(&{{.Model}}s).Count(&countRows)
	p := paginator.NewPagintor(0, countRows)
	orm.Master().Table("{{.CVal}}").Offset(num).Limit(p.Rows).Find(&{{.Model}}s)
	rownum := countRows / p.Rows
	return g.Map{"rownum": rownum + 1, "rows": len({{.Model}}s), "data": {{.Model}}s}
}

func ({{.Model}}Service *{{.CStruct}}Service) Info(id int) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := model.{{.CStruct}}{}
	err := orm.Master().Table("{{.CVal}}").First(&{{.Model}}, "id = ?", {{.Model}}Id).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Warn(err)
		return nil, errors.New("记录不存在")
	}
	return gconv.Map({{.Model}}), nil
}

func ({{.Model}}Service *{{.CStruct}}Service) Create(req req.Create{{.CStruct}}) (g.Map, error) {
	{{.Model}} := model.{{.CStruct}}{}
	//检查条件
	//err := orm.Master().First(&{{.model}}, "title = ?", {{.Model}}Id).Error
	//if err == gorm.ErrRecordNotFound {
	//	app.Logger().Error(err)
	//	return nil, errors.New("数据未找到")
	//}
	//保存
	query := orm.Master().Table("{{.CVal}}").Save(&{{.Model}})
	rows := query.RowsAffected
	err := query.Error
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, err
	}
	return gconv.Map({{.Model}}), nil
}

func ({{.Model}}Service *{{.CStruct}}Service) Edit(id int, req req.Edit{{.CStruct}}) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := model.{{.CStruct}}{}
	err := orm.Master().First(&{{.Model}} , "id = ?", {{.Model}}Id).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("{{.CVal}}").Where("id = ?", id).Updates(&{{.Model}})
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("保存失败")
	}
	return gconv.Map({{.Model}}), nil
}

func ({{.Model}}Service *{{.CStruct}}Service) Delete(id int) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := model.{{.CStruct}}{}
	err := orm.Master().Table("{{.CVal}}").First(&{{.Model}}, "id = ?", {{.Model}}Id).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("{{.CVal}}").Delete(&{{.Model}})
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("系统错误")
	}
	return nil, nil
}
