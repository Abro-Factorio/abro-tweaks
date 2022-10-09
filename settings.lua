_G.data:extend({
	{
		type = "double-setting",
		name = "abro-tweaks-maxfactor",
		setting_type = "runtime-global",
        minimum_value = 0,
		maximum_value = 1,
		default_value = 1
	},
	{
		type = "bool-setting",
		name = "abro-tweaks-global-chat",
		setting_type = "runtime-global",
		default_value = true
	},
	{
		type = "double-setting",
		name = "abro-tweaks-chat-color-multiplier",
		setting_type = "runtime-global",
        minimum_value = 0,
		maximum_value = 1,
		default_value = 0.8
	},
	{
		type = "double-setting",
		name = "abro-tweaks-teleport-radius",
		setting_type = "runtime-global",
        minimum_value = 0,
		maximum_value = 32,
		default_value = 5
	}
})
