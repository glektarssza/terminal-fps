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

Test_Struct :: struct {
	id: u64,
}

@(test)
test_create_registry :: proc(t: ^testing.T) {
	//-- Given

	//-- When
	r, err := terminal_fps.create_registry(Test_Struct)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect(t, r != nil)
}

@(test)
test_registry_insert :: proc(t: ^testing.T) {
	//-- Given
	namespace := "some_random_namespace"
	location := "a_test/location"
	registry_id := terminal_fps.Registry_ID{namespace, location}
	registry, _ := terminal_fps.create_registry(Test_Struct)
	value := Test_Struct{}

	//-- When
	err := terminal_fps.registry_insert(registry, registry_id, value)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)

	//-- Given

	//-- When
	err = terminal_fps.registry_insert(registry, registry_id, value)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.Registry_ID_Already_Taken,
			allocator_error_code = nil,
		},
	)
}

@(test)
test_registry_get :: proc(t: ^testing.T) {
	//-- Given
	namespace := "some_random_namespace"
	location := "a_test/location"
	registry_id := terminal_fps.Registry_ID{namespace, location}
	registry, _ := terminal_fps.create_registry(Test_Struct)
	value := Test_Struct {
		id = 123,
	}

	//-- When
	r, err := terminal_fps.registry_get(registry, registry_id)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.Registry_ID_Not_Found,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, Test_Struct{})

	//-- Given
	_ = terminal_fps.registry_insert(registry, registry_id, value)

	//-- When
	r, err = terminal_fps.registry_get(registry, registry_id)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, value)
}

@(test)
test_registry_has_id :: proc(t: ^testing.T) {
	//-- Given
	namespace := "some_random_namespace"
	location := "a_test/location"
	registry_id := terminal_fps.Registry_ID{namespace, location}
	registry, _ := terminal_fps.create_registry(Test_Struct)
	value := Test_Struct {
		id = 123,
	}

	//-- When
	r, err := terminal_fps.registry_has_id(registry, registry_id)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, false)

	//-- Given
	_ = terminal_fps.registry_insert(registry, registry_id, value)

	//-- When
	r, err = terminal_fps.registry_has_id(registry, registry_id)

	//-- Then
	testing.expect_value(
		t,
		err,
		terminal_fps.Registry_Error {
			code = terminal_fps.Registry_Error_Code.No_Error,
			allocator_error_code = nil,
		},
	)
	testing.expect_value(t, r, true)

}
