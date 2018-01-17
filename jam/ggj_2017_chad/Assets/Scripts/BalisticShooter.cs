
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BalisticShooter : MonoBehaviour
{
    private SpawnInstruction instrucion;
    private int numberOfSpawns;
    private float delay;
    private List<GameObject> spawns;
    private GameObject spawnObject;
    private AudioSource sfxSource;

    void Start()
    {
        spawns = new List<GameObject>();
        sfxSource = GetComponent<AudioSource>();
    }

    void Update ()
    {
        delay -= Time.deltaTime;
        if (delay < 0 && numberOfSpawns > 0)
        {
            Spawn();
            delay = instrucion.delayBetweenEachSpawn;
            numberOfSpawns--;
        }
    }

    void OnDestroy()
    {
        foreach(GameObject spawn in spawns)
        {
            Destroy(spawn);
        }

        spawns = new List<GameObject>();
    }

    public void SetInstruction(SpawnInstruction instruction)
    {
        this.instrucion = instruction;
        spawnObject = Resources.Load(instrucion.objectToSpawn) as GameObject;
        delay = instrucion.delayBetweenEachSpawn;
        numberOfSpawns = instrucion.numberOfSpawns;
    }

    private void Spawn()
    {
        
        GameObject spawned = Instantiate(spawnObject, this.transform.position, new Quaternion(1, 0, 0, 1));
        spawned.GetComponent<Balistic>().Direction = instrucion.direction;

        spawns.Add(spawned);

		if (SoundManager.Instance)
		{
			SoundManager.Instance.PlayBarrelShotSound(sfxSource);
		}
    }
}
