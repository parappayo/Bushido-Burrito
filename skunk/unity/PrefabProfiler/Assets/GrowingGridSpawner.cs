
using UnityEngine;

public class GrowingGridSpawner : MonoBehaviour
{
    public GameObject Spawnable;
    public uint StepSize = 100;
    public float StepDelay = 2f;
    public float Spacing = 10f;

    private float TimeSinceLastStep = 0f;
    private uint StepCount = 0;

    public uint SpawnCount { get { return StepSize * StepCount; } }

    private void Update()
    {
        TimeSinceLastStep -= Time.deltaTime;

        if (TimeSinceLastStep <= 0f) {
            SpawnWave();
            TimeSinceLastStep = StepDelay;
        }
    }

    private void SpawnWave()
    {
        for (uint i = 0; i < StepSize; i++) {
            var spawn = Instantiate(Spawnable) as GameObject;
            spawn.transform.parent = transform;
            spawn.transform.position = new Vector3((float) i * Spacing, 0f, (float) StepCount * Spacing);
        }

        StepCount++;
    }
}
