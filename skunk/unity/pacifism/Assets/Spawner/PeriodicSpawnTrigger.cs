
using UnityEngine;

public class PeriodicSpawnTrigger : MonoBehaviour
{
	public float Period = 0.5f;

	private float Timer = 0f;

	private void Start()
	{
		Spawner spawner = GetComponent<Spawner>();
		if (spawner != null)
		{
			spawner.ShouldSpawn = ShouldSpawn;
		}
		else
		{
			PooledSpawner pooledSpawner = GetComponent<PooledSpawner>();
			if (pooledSpawner != null)
			{
				pooledSpawner.ShouldSpawn = ShouldSpawn;
			}
			else
			{
				Debug.LogWarning("spawn trigger could not find spawner");
			}
		}
	}

	private bool ShouldSpawn(float elapsedTime)
	{
		Timer -= elapsedTime;

		if (Timer <= 0f)
		{
			Timer = Period;
			return true;
		}

		return false;
	}
}
