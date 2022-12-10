package main

import (
	"simple/internal/foundation/engine"
	"simple/internal/foundation/server"
	"simple/internal/router"
)

func main() {
	//go:generator
	server.Mode = "admin"
	// pages.New(&Table).List(ctx)
	server.Run(func(engine engine.Engine) { engine.Run(router.Admin) })
}
