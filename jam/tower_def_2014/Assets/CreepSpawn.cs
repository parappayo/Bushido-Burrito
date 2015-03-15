using UnityEngine;
using System.Collections;

public class CreepSpawn : MonoBehaviour
{
	public GameObject CreepPrefab;
	public GameObject FirstNavPoint;
	public float SpawnPeriod;
	
	private float LastSpawnTime;
	
	void Start()
	{
		Spawn();
	}
	
	void Update()
	{
		if (Time.time - LastSpawnTime > SpawnPeriod)
		{
			Spawn();
		}
	}

	private void Spawn()
	{
		LastSpawnTime = Time.time;
		GameObject newCreep = Instantiate(CreepPrefab, transform.position, Quaternion.identity) as GameObject;
		newCreep.GetComponent<FollowNavPoints>().CurrentNavPoint = FirstNavPoint;
	}
}
