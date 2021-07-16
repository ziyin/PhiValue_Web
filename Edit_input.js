	function Edit_ProValue(Input_value) {
		Input_value.value = Input_value.value.replace(/[\W]/g, "");
	}

	function Edit_MutValue(Input_value) {
		Input_value.value = Input_value.value.replace(
				/[^arndbcqezghilkmfpstwyvARNDBCQEZGHILKMFPSTWYV]/g, "");
	}

	function Edit_digital(Input_value) {
		Input_value.value = Input_value.value.replace(/[^((\d+\.)?(\d)+)]/, "");
	}