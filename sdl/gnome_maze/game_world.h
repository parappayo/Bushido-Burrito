
#ifndef __GAME_WORLD_H__
#define __GAME_WORLD_H__

#include <vector>
using namespace std;

#include "game_objects.h"

namespace GnomeMaze {

class GameWorld
{
public:
	GameWorld();
	~GameWorld();

	void Add(GameObject* obj);
	void Remove(GameObject* obj);

	void Populate(void);  // add some test data

	void Update(int ticks);
	void Render(void);

	// update player view direction based on changes in mouse position
	void UpdateMouselook(int dx, int dy);

	// player movement
	void SetPlayerMoveForward(bool value);
	void SetPlayerMoveBack(bool value);
	void SetPlayerMoveLeft(bool value);
	void SetPlayerMoveRight(bool value);

protected:
	vector<GameObject*> game_objects;

	Point player_pos;
	float player_xrot, player_yrot;
	bool player_move_up, player_move_down, player_move_left, player_move_right;

};

} // namespace GnomeMaze

#endif // __GAME_WORLD_H__
