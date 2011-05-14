
#include "game_objects.h"

namespace GnomeMaze {

Point::Point()
: x(0.0f)
, y(0.0f)
, z(0.0f)
{}

Color::Color()
: r(1.0f)
, g(1.0f)
, b(1.0f)
{}

GameObject::GameObject()
{
}

void GameObject::Collide(Point& old_pos, Point& new_pos, Point& result)
{
	// no collision by default
	result = new_pos;
}

Gnome::Gnome()
{
	texture = 0;
	rot = 0.0f;
}

Gnome::~Gnome()
{
}

void Gnome::Render(void)
{
	glPushMatrix();

	glTranslatef(pos.x, pos.y, pos.z);
	glColor3f(color.r, color.g, color.b);
	glRotatef(rot, 0.0f, 1.0f, 0.0f);
	glBindTexture(GL_TEXTURE_2D, texture);
	glBegin(GL_QUADS);
		glTexCoord2f(0.0f, 0.0f);	glVertex3f(-1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f( 1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 0.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 0.0f);
	glEnd();

	glPopMatrix();
}

void Gnome::Update(int ticks)
{
	rot += 0.05f * (float) ticks;
	if (rot > 360.f) { rot = 0.0f; }
}

MazeBlock::MazeBlock()
{
	texture = 0;
}

MazeBlock::~MazeBlock()
{
}

void MazeBlock::Render(void)
{
	glPushMatrix();

	glTranslatef(pos.x, pos.y, pos.z);
	glColor3f(color.r, color.g, color.b);
	glBindTexture(GL_TEXTURE_2D, texture);

	glBegin(GL_QUADS);
		// front wall
		glTexCoord2f(0.0f, 0.0f);	glVertex3f(-1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f( 1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 0.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 0.0f);
		// back wall
		glTexCoord2f(0.0f, 0.0f);	glVertex3f(-1.0f,  1.0f, 2.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f( 1.0f,  1.0f, 2.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 2.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 2.0f);
		// left wall
		glTexCoord2f(0.0f, 0.0f);	glVertex3f(-1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f(-1.0f,  1.0f, 2.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 2.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 0.0f);
		// right wall
		glTexCoord2f(0.0f, 0.0f);	glVertex3f( 1.0f,  1.0f, 0.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f( 1.0f,  1.0f, 2.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 2.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 0.0f);
	glEnd();

	glPopMatrix();
}

void MazeBlock::Collide(Point& old_pos, Point& new_pos, Point& result)
{
	const float margin = 0.25f;

	bool x_col = new_pos.x > pos.x - 1.0f - margin && new_pos.x < pos.x + 1.0f + margin;
	bool z_col = new_pos.z > pos.z - 0.0f - margin && new_pos.z < pos.z + 2.0f + margin;

	if (x_col && z_col) {
		// TODO: implement "slippery" collision
		result.x = old_pos.x;
		result.z = old_pos.z;
	} else {
		result.x = new_pos.x;
		result.z = new_pos.z;
	}
}

FloorTile::FloorTile()
{
	texture = 0;
}

FloorTile::~FloorTile()
{
}

void FloorTile::Render(void)
{
	glPushMatrix();

	glTranslatef(pos.x, pos.y, pos.z);
	glColor3f(color.r, color.g, color.b);
	glBindTexture(GL_TEXTURE_2D, texture);

	glBegin(GL_QUADS);
		glTexCoord2f(0.0f, 0.0f);	glVertex3f(-1.0f, -1.0f, 0.0f);
		glTexCoord2f(1.0f, 0.0f);	glVertex3f( 1.0f, -1.0f, 0.0f);
		glTexCoord2f(1.0f, 1.0f);	glVertex3f( 1.0f, -1.0f, 2.0f);
		glTexCoord2f(0.0f, 1.0f);	glVertex3f(-1.0f, -1.0f, 2.0f);
	glEnd();

	glPopMatrix();
}

Maze::Maze()
: block_texture(0)
, floor_texture(0)
{
}

Maze::~Maze()
{
}

void Maze::Render(void)
{
	glPushMatrix();

	MazeBlock temp_block;
	FloorTile temp_floor;
	temp_block.texture = block_texture;
	temp_floor.texture = floor_texture;
	temp_block.color = color;
	temp_floor.color = color;

	for (int y = 0; y < maze_height; y++) {
		for (int x = 0; x < maze_width; x++) {
			if (maze_data[y * maze_height + x]) {
				temp_block.pos.x = pos.x + 2.0f * x;
				temp_block.pos.z = pos.z + -2.0f * y;
				temp_block.Render();
			} else {
				temp_floor.pos.x = pos.x + 2.0f * x;
				temp_floor.pos.z = pos.z + -2.0f * y;
				temp_floor.Render();
			}
		}
	}

	glPopMatrix();
}

void Maze::Collide(Point& old_pos, Point& new_pos, Point& result)
{
	MazeBlock temp_block;

	for (int y = 0; y < maze_height; y++) {
		for (int x = 0; x < maze_width; x++) {
			if (maze_data[y * maze_height + x]) {
				temp_block.pos.x = pos.x + 2.0f * x;
				temp_block.pos.z = pos.z + -2.0f * y;
				temp_block.Collide(old_pos, new_pos, result);
				new_pos = result;
			}
		}
	}
}

const char Maze::maze_data[1024] = {
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
};

} // namespace GnomeMaze
