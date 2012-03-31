--
--  map_data.lua - Tango Uniform maps
--

-- global settings
num_terrain_types = 8  -- TODO: should be set in C#
test_terrain_width = 50
test_terrain_height = 50

-- generate test data set
function generate_test_terrain()
	terrain = {}
	size = test_terrain_width * test_terrain_height
	for i = 0, size-1 do
		terrain[i] = i % num_terrain_types
	end
	return terrain
end

-- for now, "test" is auto-loaded in game
MapData{
	id = "test",
	width = test_terrain_width,
	height = test_terrain_height,
	terrain = generate_test_terrain()
}

-- this data set is still seen by the game, but is ignored for now :(
MapData{
	id = "test2",
	width = 5,
	height = 3,

	terrain = {
		1, 3, 3, 1, 2,
		1, 1, 3, 2, 1,
		2, 3, 1, 1, 2
	}
}

