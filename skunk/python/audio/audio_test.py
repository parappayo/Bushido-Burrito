
# playing around with code found here,
#  https://stackoverflow.com/questions/8299303/generating-sine-wave-sound-in-python

import pyaudio
import numpy

volume = 0.2
freq = 440.0
sample_rate_hz = 44100
duration_secs = 1.0

samples = (numpy.sin(2 * numpy.pi * numpy.arange(sample_rate_hz * duration_secs) * freq / sample_rate_hz)).astype(numpy.float32)

p = pyaudio.PyAudio()

stream = p.open(format=pyaudio.paFloat32,
				channels=1,
				rate=sample_rate_hz,
				output=True)

stream.write((volume*samples).tobytes())
stream.stop_stream()
stream.close()
p.terminate()
