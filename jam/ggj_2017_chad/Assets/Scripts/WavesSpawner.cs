using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WavesSpawner : MonoBehaviour {

    public GameObject Wave;

    private const int TIMER_DEFAULT = 9;

    private float timeLeft = 0;
    private Dictionary<string, GameObject> spawnPoints;
    private WavesSpawnData spawnData;
    private List<GameObject> currentSpawns;
    private WaveDef currentWaveDef;

    private WaveMotion _WaveMotion;
    private RockTheBoat _Boat;

    void Start () {

        currentSpawns = new List<GameObject>();

        // Get all spawn points and keep a reference to them
        var spawnPointsSearch = GameObject.FindGameObjectsWithTag("SpawnPoints");
        spawnPoints = new Dictionary<string, GameObject>();
        foreach (GameObject spawnPoint in spawnPointsSearch)
        {
            spawnPoints[spawnPoint.name] = spawnPoint;
        }

        spawnData = this.GetComponent<WavesSpawnData>();
        StartNextWave();

        if (!Wave)
        {
            Debug.Log("wave spawner does not have wave gameobject set");
        }
        else
        {
            _WaveMotion = Wave.GetComponent<WaveMotion>();
        }

        _Boat = GameObject.FindObjectOfType<RockTheBoat>();
    }

    private void StartNextWave()
    {
        currentWaveDef = spawnData.GetNextWave();
        if (currentWaveDef != null)
        {
            timeLeft = currentWaveDef.time;
        }
        else
        {
            // TODO: spawn a random wave? or end the game?
            timeLeft = TIMER_DEFAULT;
        }
    }

	void Update () {

        timeLeft -= Time.deltaTime;

        if (_WaveMotion != null && !_WaveMotion.IsPlaying)
        {
            float waveLeadTime = _WaveMotion.Duration / 2f;

            if (Wave && timeLeft < waveLeadTime)
            {
                Wave.SendMessage("Trigger", null, SendMessageOptions.RequireReceiver);
            }
        }

        if (timeLeft < 0)
        {
            Spawn(currentWaveDef);
            StartNextWave();
        }
    }

    private void Spawn(WaveDef waveDef) {
        // Get assigned spawn points
        // And create objects
        // Clear the previous wave
        if (waveDef != null)
        {
            foreach (GameObject spawn in currentSpawns)
            {
                if (spawn != null)
                {
                    Destroy(spawn);
                }
            }
            foreach (SpawnInstruction spawnInstruction in waveDef.content)
            {
                
                if (spawnInstruction.operation == null)
                {
                    GameObject foundObject = Resources.Load(spawnInstruction.objectToSpawn) as GameObject;
                    GameObject targetObject = Instantiate(foundObject, spawnPoints[spawnInstruction.spawnPoint].transform.position, new Quaternion());
                    targetObject.transform.parent = spawnPoints[spawnInstruction.spawnPoint].transform.parent;
                    currentSpawns.Add(targetObject);
                }
                else
                {
                    if (spawnInstruction.operation == "Shoot")
                    {
                        GameObject foundObject = Resources.Load("Shooter") as GameObject;
                        GameObject targetObject = Instantiate(foundObject, spawnPoints[spawnInstruction.spawnPoint].transform.position, new Quaternion());
                        targetObject.transform.parent = spawnPoints[spawnInstruction.spawnPoint].transform.parent;
                        targetObject.GetComponent<BalisticShooter>().SetInstruction(spawnInstruction);

                        currentSpawns.Add(targetObject);
                    }
                }
            }

            // Boat rocking
            _Boat.SetRocking(waveDef);
        }
    }
}
