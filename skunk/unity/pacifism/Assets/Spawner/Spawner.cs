
using UnityEngine;

public class Spawner : MonoBehaviour
{
	public GameObject Spawnable;
	public GameObject SpawnParent;
	public bool ActivateSpawnable = true;

	public float TimeScale = 1f;

	public delegate bool TriggerDelegate(float t);
	public TriggerDelegate ShouldSpawn;

	public delegate Vector3 PositionDelegate();
	public PositionDelegate SpawnPosition;

	private void FixedUpdate()
	{
		if (ShouldSpawn == null) { return; }

		if (ShouldSpawn(Time.deltaTime * TimeScale))
		{
			Spawn();
		}
	}

	public void Spawn()
	{
		if (Spawnable == null) { return; }

		GameObject spawnObject = Instantiate(Spawnable);

		spawnObject.transform.position = SpawnPosition != null ? SpawnPosition() : transform.position;

		if (ActivateSpawnable)
		{
			spawnObject.SetActive(true);
		}

		if (SpawnParent != null)
		{
			spawnObject.transform.parent = SpawnParent.transform;
		}
	}
}
