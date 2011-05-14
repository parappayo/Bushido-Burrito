
#include "game_world.h"

#include <GL/gl.h>
#include <math.h>
#include "utils.h"

namespace GnomeMaze {

GameWorld::GameWorld()
{
	player_pos.x = 0.0f;
	player_pos.y = 0.0f;
	player_pos.z = 0.0f;
	player_xrot = 0.0f;
	player_yrot = 0.0f;
	player_move_up = false;
	player_move_down = false;
	player_move_left = false;
	player_move_right = false;
}

GameWorld::~GameWorld()
{

}

void GameWorld::Add(GameObject* obj)
{
	if (obj == NULL) { return; }
	game_objects.push_back(obj);
}

void GameWorld::Remove(GameObject* obj)
{
	if (obj == NULL) { return; }
	vector<GameObject*>::iterator i;
	for (i = game_objects.begin(); i != game_objects.end(); i++) {
		if (*i == obj) break;
	}
	if (i != game_objects.end()) {
		game_objects.erase(i);
	}
}

void GameWorld::Update(int ticks)
{
	// update game objects
	for (vector<GameObject*>::iterator i = game_objects.begin(); i != game_objects.end(); i++) {
		if (*i != NULL) {
			(*i)->Update(ticks);
		}
	}

	// update player position
	const float move_scale = 0.005f;
	Point old_player_pos = player_pos;
	Point new_player_pos = player_pos;
	if (player_move_up) {
		// TODO: use fast_sin and fast_cos instead
		new_player_pos.x -= (float) sin(player_xrot * pi_over_180) * move_scale * ticks;
		new_player_pos.z -= (float) cos(player_xrot * pi_over_180) * move_scale * ticks;
	}
	if (player_move_down) {
		new_player_pos.x += (float) sin(player_xrot * pi_over_180) * move_scale * ticks;
		new_player_pos.z += (float) cos(player_xrot * pi_over_180) * move_scale * ticks;
	}
	if (player_move_left) {
		new_player_pos.x -= (float) sin((player_xrot + 90.0f) * pi_over_180) * move_scale * ticks;
		new_player_pos.z -= (float) cos((player_xrot + 90.0f) * pi_over_180) * move_scale * ticks;
	}
	if (player_move_right) {
		new_player_pos.x += (float) sin((player_xrot + 90.0f) * pi_over_180) * move_scale * ticks;
		new_player_pos.z += (float) cos((player_xrot + 90.0f) * pi_over_180) * move_scale * ticks;
	}

	// collision detection
	for (vector<GameObject*>::iterator i = game_objects.begin(); i != game_objects.end(); i++) {
		if (*i != NULL) {
			(*i)->Collide(old_player_pos, new_player_pos, player_pos);
		}
	}
}

void GameWorld::Render(void)
{
	glPushMatrix();

	glLoadIdentity();
	float view_x = player_pos.x - (float) sin(player_xrot * pi_over_180);
	float view_z = player_pos.z - (float) cos(player_xrot * pi_over_180);
	float view_y = player_pos.y - (float) sin(player_yrot * pi_over_180);
	gluLookAt(
		player_pos.x, player_pos.y, player_pos.z,
		view_x, view_y, view_z,
		0.0f, 1.0f, 0.0f);
	
	for (vector<GameObject*>::iterator i = game_objects.begin(); i != game_objects.end(); i++) {
		if (*i != NULL) {
			(*i)->Render();
		}
	}

	glPopMatrix();
}

void GameWorld::Populate(void)
{
	static Maze maze;
	maze.block_texture = LoadTexture("textures/hedge.jpg");
	maze.floor_texture = LoadTexture("textures/brick.jpg");
	// put the user in the center of the maze
	maze.pos.x = -32.0f;
	maze.pos.z = 32.0f;
	Add(&maze);

	static Gnome test1;
	test1.texture = LoadTexture("textures/wow_gnome_1_17.jpg");
	test1.pos.z = -6.0f;
	Add(&test1);

	static Gnome test2;
	test2.texture = LoadTexture("textures/gnome.jpg");
	test2.pos.x = 0.5f;
	test2.pos.z = -5.5f;
	Add(&test2);

	static MazeBlock test3;
	test3.texture = LoadTexture("textures/brick.jpg");
	test3.pos.z = -12.0f;
	//Add(&test3);
}

void GameWorld::UpdateMouselook(int dx, int dy)
{
	static bool first_call = true;
	if (first_call) {
		first_call = false;
		return;
	}

	const float mouse_scale = 0.5f;
	player_xrot -= mouse_scale * (float) dx;
	player_yrot += mouse_scale * (float) dy;

	while (player_xrot < 0.0f) { player_xrot += 360.f; }
	while (player_xrot >= 360.0f) { player_xrot -= 360.0f; }
	if (player_yrot < -89.0f) { player_yrot = -89.0f; }
	if (player_yrot > 89.0f) { player_yrot = 89.0f; }
}

void GameWorld::SetPlayerMoveForward(bool value)
{
	player_move_up = value;
}

void GameWorld::SetPlayerMoveBack(bool value)
{
	player_move_down = value;
}

void GameWorld::SetPlayerMoveLeft(bool value)
{
	player_move_left = value;
}

void GameWorld::SetPlayerMoveRight(bool value)
{
	player_move_right = value;
}

} // namespace GnomeMaze
