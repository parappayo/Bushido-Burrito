
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

audio = pyaudio.PyAudio()

stream = audio.open(format=pyaudio.paFloat32,
				channels=1,
				rate=sample_rate_hz,
				output=True)

stream.write((volume * generate_samples(1.0, note_freq.A4)).tobytes())
stream.stop_stream()
stream.close()
audio.terminate()
