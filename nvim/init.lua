local function load_config_files()
	local config_dir = vim.fn.stdpath("config") .. "/lua/config"
	local files = vim.fn.glob(config_dir .. "/*.lua", false, true)
	for _, file in ipairs(files) do
		local module_name = vim.fn.fnamemodify(file, ":t:r")
		if module_name ~= "init" then -- Avoid loading init.lua if it exists
			local success, err = pcall(require, "config." .. module_name)
			if not success then
				vim.notify(
					"Error loading " .. module_name .. ": " .. err,
					vim.log.levels.ERROR
				)
			end
		end
	end
end


load_config_files()

