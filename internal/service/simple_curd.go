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

type SimpleCurdService struct {
}

func (simpleCurdService *SimpleCurdService) List(num int) g.Map {
	var simpleCurds []model.SimpleCurd
	var countRows int
	orm.Master().Find(&simpleCurds).Count(&countRows)
	p := paginator.NewPagintor(0, countRows)
	orm.Master().Table("simple_curd").Offset(num).Limit(p.Rows).Find(&simpleCurds)
	rownum := countRows / p.Rows
	return g.Map{"rownum": rownum + 1, "rows": len(simpleCurds), "data": simpleCurds}
}

func (simpleCurdService *SimpleCurdService) Info(id int) (g.Map, error) {
	simpleCurdId := gconv.Int(id)
	simpleCurd := model.SimpleCurd{}
	err := orm.Master().Table("simple_curd").First(&simpleCurd, "id = ?", simpleCurdId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Warn(err)
		return nil, errors.New("记录不存在")
	}
	return gconv.Map(simpleCurd), nil
}

func (simpleCurdService *SimpleCurdService) Create(req req.CreateSimpleCurd) (g.Map, error) {
	simpleCurd := model.SimpleCurd{}
	//检查条件
	//err := orm.Master().First(&, "title = ?", simpleCurdId).Error
	//if err == gorm.ErrRecordNotFound {
	//	app.Logger().Error(err)
	//	return nil, errors.New("数据未找到")
	//}
	//保存
	query := orm.Master().Table("simple_curd").Save(&simpleCurd)
	rows := query.RowsAffected
	err := query.Error
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, err
	}
	return gconv.Map(simpleCurd), nil
}

func (simpleCurdService *SimpleCurdService) Edit(id int, req req.EditSimpleCurd) (g.Map, error) {
	simpleCurdId := gconv.Int(id)
	simpleCurd := model.SimpleCurd{}
	err := orm.Master().First(&simpleCurd , "id = ?", simpleCurdId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("simple_curd").Where("id = ?", id).Updates(&simpleCurd)
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("保存失败")
	}
	return gconv.Map(simpleCurd), nil
}

func (simpleCurdService *SimpleCurdService) Delete(id int) (g.Map, error) {
	simpleCurdId := gconv.Int(id)
	simpleCurd := model.SimpleCurd{}
	err := orm.Master().Table("simple_curd").First(&simpleCurd, "id = ?", simpleCurdId).Error
	if err == gorm.ErrRecordNotFound {
		app.Logger().Error(err)
		return nil, errors.New("数据未找到")
	}
	query := orm.Master().Table("simple_curd").Delete(&simpleCurd)
	rows := query.RowsAffected
	if rows == 0 || err != nil {
		app.Logger().Error(err)
		return nil, errors.New("系统错误")
	}
	return nil, nil
}
