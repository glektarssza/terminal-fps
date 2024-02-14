package test_terminal_fps

import terminal_fps "app:src"
import "core:strings"
import "core:testing"

@(test)
test_create_registry_id_from_string :: proc(t: ^testing.T) {
	//-- Given
	namespace := "some_random_namespace"
	location := "a_test/location"
	registry_id_string := strings.concatenate({namespace, ":", location})

	//-- When
	r, err := terminal_fps.create_registry_id_from_string(registry_id_string)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, terminal_fps.Registry_ID{namespace, location})

	//-- Given
	registry_id_string = strings.concatenate({namespace, location})

	//-- When
	r, err = terminal_fps.create_registry_id_from_string(registry_id_string)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.Invalid_Registry_ID,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, terminal_fps.Registry_ID{namespace = "", location = ""})
}

@(test)
test_registry_id_to_string :: proc(t: ^testing.T) {
	//-- Given
	namespace := "some_random_namespace"
	location := "a_test/location"
	registry_id := terminal_fps.Registry_ID{namespace, location}

	//-- When
	r, err := terminal_fps.registry_id_to_string(registry_id)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, "some_random_namespace:a_test/location")
}

}
