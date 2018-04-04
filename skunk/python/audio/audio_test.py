
# playing around with code found here,
#  https://stackoverflow.com/questions/8299303/generating-sine-wave-sound-in-python

import pyaudio
import numpy
import note_freq

volume = 0.2
sample_rate_hz = 44100

tau = 2 * numpy.pi

def generate_samples(duration_secs, freq_hz):
	return (numpy.sin(tau * numpy.arange(sample_rate_hz * duration_secs) * freq_hz / sample_rate_hz)).astype(numpy.float32)

def play_note(freq, volume, duration, stream):
	stream.write((numpy.clip(volume, 0, 1.0) * generate_samples(duration, freq)).tobytes())

if __name__ == "__main__":
	audio = pyaudio.PyAudio()

	stream = audio.open(format=pyaudio.paFloat32,
					channels=1,
					rate=sample_rate_hz,
					output=True)

	play_note(note_freq.A3, 0.2, 1.0, stream)
	play_note(note_freq.B3, 0.2, 1.0, stream)
	play_note(note_freq.C4, 0.2, 1.0, stream)
	play_note(note_freq.D4, 0.2, 1.0, stream)

	stream.stop_stream()
	stream.close()
	audio.terminate()
