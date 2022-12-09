package entitys

import (
	"gorm.io/gorm"
)

//迁移任务
type MigrateJob interface {
	Down(db *gorm.DB)
	Up(db *gorm.DB)
	FileName() string
}

var Job = []MigrateJob{}
