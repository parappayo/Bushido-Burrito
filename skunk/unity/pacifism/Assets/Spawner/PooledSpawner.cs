using UnityEngine;

public class PooledSpawner : MonoBehaviour
{
	public ObjectPool Pool;

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
		GameObject spawnObject = Pool.Get();

		var poolable = spawnObject.GetComponent<Poolable>();
		if (poolable != null)
		{
			poolable.Spawner = this;
		}
		else
		{
			Debug.LogWarning("expected object pool to contain poolable objects");
		}

		spawnObject.transform.position = SpawnPosition != null ? SpawnPosition() : transform.position;

		if (ActivateSpawnable)
		{
			spawnObject.SetActive(true);
		}
	}

	public void Free(GameObject gameObject)
	{
		if (ActivateSpawnable)
		{
			gameObject.SetActive(false);
		}

		Pool.Free(gameObject);
	}
}
