package store

type User struct {
	Id        int    `gorm:"id"`
	Name      string `gorm:"name"`
	CreatedAt string `gorm:"name"`
}
