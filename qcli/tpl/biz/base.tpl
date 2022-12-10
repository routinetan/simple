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
)

type {{.CStruct}}Biz struct {
}

func ({{.Model}}Biz *{{.CStruct}}Biz) List(num int) g.Map {
	var {{.Model}}s []store.{{.CStruct}}
	var countRows int
	orm.Master().Find(&{{.Model}}s).Count(&countRows)
	p := paginator.NewPagintor(0, countRows)
	orm.Master().Table("{{.CVal}}").Offset(num).Limit(p.Rows).Find(&{{.Model}}s)
	rownum := countRows / p.Rows
	return g.Map{"rownum": rownum + 1, "rows": len({{.Model}}s), "data": {{.Model}}s}
}

func ({{.Model}}Biz *{{.CStruct}}Biz) Info(id int) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := store.{{.CStruct}}{}
	err := orm.Master().Table("{{.CVal}}").First(&{{.Model}}, "id = ?", {{.Model}}Id).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Warn(err)
		return nil, errors.New("记录不存在")
	}
	return gconv.Map({{.Model}}), nil
}

func ({{.Model}}Biz *{{.CStruct}}Biz) Create(req req.Create{{.CStruct}}) (g.Map, error) {
	{{.Model}} := store.{{.CStruct}}{}
	//检查条件
	//err := orm.Master().First(&{{.store}}, "title = ?", {{.Model}}Id).Error
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

func ({{.Model}}Biz *{{.CStruct}}Biz) Edit(id int, req req.Edit{{.CStruct}}) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := store.{{.CStruct}}{}
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

func ({{.Model}}Biz *{{.CStruct}}Biz) Delete(id int) (g.Map, error) {
	{{.Model}}Id := gconv.Int(id)
	{{.Model}} := store.{{.CStruct}}{}
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
