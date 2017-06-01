
using UnityEngine;

public class RandomRectBoundsSpawnPosition : MonoBehaviour
{
	public Vector3 Min;
	public Vector3 Max;

	private void Start()
	{
		Spawner spawner = GetComponent<Spawner>();
		if (spawner != null)
		{
			spawner.SpawnPosition = SpawnPosition;
		}
		else
		{
			PooledSpawner pooledSpawner = GetComponent<PooledSpawner>();
			if (pooledSpawner != null)
			{
				pooledSpawner.SpawnPosition = SpawnPosition;
			}
			else
			{
				Debug.LogWarning("spawn trigger could not find spawner");
			}
		}
	}

	private Vector3 SpawnPosition()
	{
		return new Vector3(
				Random.Range(Min.x, Max.x),
				Random.Range(Min.y, Max.y),
				Random.Range(Min.z, Max.z)
			);
	}
}
