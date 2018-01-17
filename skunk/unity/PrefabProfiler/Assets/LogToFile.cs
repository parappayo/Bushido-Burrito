
using System.IO;

using UnityEngine;

public class LogToFile : MonoBehaviour
{
    public ShowFPS FPS;
    public GrowingGridSpawner Spawner;

    public float LogDelay = 1f;
    public string LogPath;

    private float TimeSinceLastLog = 0f;

    private void Update()
    {
        TimeSinceLastLog -= Time.deltaTime;

        if (TimeSinceLastLog <= 0f) {
            OutputToLog();
            TimeSinceLastLog = LogDelay;
        }
    }

    private void OutputToLog()
    {
        bool firstWrite = !File.Exists(LogPath);
        string caption = string.Format("{0},{1:0.0},{2}", Time.time, FPS.FPS, Spawner.SpawnCount);

        using (StreamWriter writer = firstWrite ? File.CreateText(LogPath) : File.AppendText(LogPath)) {
            if (firstWrite) {
                writer.WriteLine("time,fps,spawnCount");
            }
            writer.WriteLine(caption);
        }
    }
}
