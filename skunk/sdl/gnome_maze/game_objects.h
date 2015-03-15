
#ifndef __GAME_OBJECTS_H__
#define __GAME_OBJECTS_H__

#ifdef WIN32
#include <windows.h>
#endif
#include <GL/glu.h>

namespace GnomeMaze {

class Point
{
public:
	Point();
	float x, y, z;
};

class Color
{
public:
	Color();
	float r, g, b;
};

class GameObject
{
public:
	GameObject();

	virtual void Render(void) {};
	virtual void Update(int ticks) {};
	virtual void Collide(Point& old_pos, Point& new_pos, Point& result);

	Point pos;
	Color color;
};

class Gnome : public GameObject
{
public:
	Gnome();
	~Gnome();

	virtual void Render(void);
	virtual void Update(int ticks);

	GLuint texture;
	float rot;  // fun test: rotate about y-axis
};

class MazeBlock : public GameObject
{
public:
	MazeBlock();
	~MazeBlock();

	virtual void Render(void);
	virtual void Collide(Point& old_pos, Point& new_pos, Point& result);

	GLuint texture;
};

class FloorTile : public GameObject
{
public:
	FloorTile();
	~FloorTile();

	virtual void Render(void);

	GLuint texture;
};

class Maze : public GameObject
{
public:
	Maze();
	~Maze();

	virtual void Render(void);
	virtual void Collide(Point& old_pos, Point& new_pos, Point& result);

	GLuint block_texture;
	GLuint floor_texture;

	static const int maze_height = 32;
	static const int maze_width = 32;
	static const char maze_data[1024];
};

} // namespace GnomeMaze

#endif // __GAME_OBJECTS_H__
