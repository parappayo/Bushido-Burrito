
using System.IO;

using UnityEngine;

namespace BushidoBurrito
{
	public class PrefabProfiler : MonoBehaviour
	{
		private class SampleAverager
		{
			public const uint MaxSampleCount = 5;
			public float[] Samples = new float[MaxSampleCount];

			private uint NextIndex = 0;

			public void Add(float sample)
			{
				Samples[NextIndex++] = sample;

				if (NextIndex >= MaxSampleCount) {
					NextIndex = 0;
				}
			}

			public float GetAverage()
			{
				float total = 0f;
				float max = float.MinValue;
				float min = float.MaxValue;

				for (uint i = 0; i < MaxSampleCount; i++) {
					float sample = Samples[i];
					total += sample;
					max = Mathf.Max(max, sample);
					min = Mathf.Min(min, sample);
				}

				return (total - max - min) / (MaxSampleCount - 2);
			}
		}

		public GameObject Prefab;
		public uint WaveSize = 100;
		public float Spacing = 2f;

		public string LogFilePath;

		private uint FrameCount = 0;
		private uint WaveCount = 0;

		private bool FirstLogLine = true;

		private float DeltaTime = 0.0f;
		private float FPS = 0.0f;

		private SampleAverager Samples = new SampleAverager();

		public uint SpawnCount { get { return WaveSize * WaveCount; } }

		private void Update()
		{
			UpdateFPS();

			uint step = FrameCount % 10;

			if (step == 1) {
				SpawnWave();

			} else if (step >= 4 && step <= 8) {
				Samples.Add(FPS);

			} else if (step == 9) {
				OutputToLog(SpawnCount, Samples.GetAverage());
			}

			FrameCount++;
		}

		private void UpdateFPS()
		{
			DeltaTime += (Time.unscaledDeltaTime - DeltaTime) * 0.1f;
			FPS = 1.0f / DeltaTime;
		}

		private void SpawnWave()
		{
			for (uint i = 0; i < WaveSize; i++) {
				var spawn = Instantiate(Prefab) as GameObject;
				spawn.transform.parent = transform;
				spawn.transform.position = new Vector3((float) i * Spacing, 0f, (float) WaveCount * Spacing);
			}

			WaveCount++;
		}

		private void OutputToLog(uint spawnCount, float fps)
		{
			if (string.IsNullOrEmpty(LogFilePath)) { return; }

			string caption = string.Format("{0},{1:0.0}", spawnCount, fps);

			using (StreamWriter writer = FirstLogLine ? File.CreateText(LogFilePath) : File.AppendText(LogFilePath)) {

				if (FirstLogLine) {
					writer.WriteLine("spawnCount,fps");
					FirstLogLine = false;
				}

				writer.WriteLine(caption);
			}
		}
	}

} // namespace BushidoBurrito
