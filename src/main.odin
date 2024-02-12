package terminal_fps

import "base:runtime"
import "core:fmt"
import "core:log"

main :: proc() {
	context.logger = log.create_console_logger(
		log.Level.Info,
		 {
			runtime.Logger_Option.Terminal_Color,
			runtime.Logger_Option.Time,
			runtime.Logger_Option.Level,
		},
		"main",
	)
	log.info("Starting main...")
	fmt.println("Hello world!")
}
