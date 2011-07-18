//------------------------------------------------------------------------------
//  Helpful web sites:
//    http://fly.cc.fer.hr/GDM/articles/sndmus/speaker1.html
//    http://bytes.com/topic/c/answers/218755-linux-speaker-beep
//    http://www.conestogac.on.ca/~set/courses/year1/embedded/intel/sound.html
//------------------------------------------------------------------------------

#include <dos.h>
#include <stdio.h>

#ifndef LOBYTE
#define LOBYTE(w) ((unsigned char) (w))
#endif

#ifndef HIBYTE
#define HIBYTE(w) ((unsigned char) (((unsigned short) (w) >> 8) & 0xFF))
#endif

#define NOTE_C4   4554
#define NOTE_C4S  4301
#define NOTE_D4   4069

//------------------------------------------------------------------------------
void speaker_play(void)
{
	// connect speaker to timer 2
	unsigned short c = inp(0x61);
	c |= 0x0003;
	outp(0x61, c);
}

//------------------------------------------------------------------------------
void speaker_stop(void)
{
	// disconnect speaker
	unsigned short c = inp(0x61);
	c &= 0xfffc;
	outp(0x61, c);
}

//------------------------------------------------------------------------------
void speaker_set_note(unsigned short interval)
{
	// load new countdown into timer 2
	outp(0x43, 0xb6);
	// send short serial data countdown
	outp(0x42, LOBYTE(interval));
	outp(0x42, HIBYTE(interval));
}

//------------------------------------------------------------------------------
int main(int argc, char* argv[])
{
	speaker_set_note(NOTE_C4); // middle C

	speaker_play();
	getc(stdin);

	speaker_set_note(NOTE_C4S); // C#
	getc(stdin);

	speaker_set_note(NOTE_D4); // D
	getc(stdin);

	speaker_stop();

	return 0;
}

