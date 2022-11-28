package main

import (
	"simple/foundation/engine"
	"simple/foundation/server"
	"simple/internal/admin"
)

func main() {
	//go:generator
	server.Mode = "admin"
	// pages.New(&Table).List(ctx)
	server.Run(func(engine engine.Engine) { engine.Run(admin.GetRouter) })
}
