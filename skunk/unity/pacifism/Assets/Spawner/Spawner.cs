
using UnityEngine;

public class Spawner : MonoBehaviour
{
	public GameObject Spawnable;
	public bool UseAsSpawnParent = true;

	public float TriggerTimeScale = 1f;

	public delegate bool TriggerDelegate(float t);
	public TriggerDelegate ShouldSpawn;

	private void FixedUpdate()
	{
		if (ShouldSpawn == null) { return; }

		if (ShouldSpawn(Time.deltaTime * TriggerTimeScale))
		{
			Spawn();
		}
	}

	public void Spawn()
	{
		if (Spawnable == null) { return; }

		GameObject spawnObject = Instantiate(Spawnable);
		spawnObject.transform.position = transform.position;
		if (UseAsSpawnParent)
		{
			spawnObject.transform.parent = transform;
		}
	}
}
