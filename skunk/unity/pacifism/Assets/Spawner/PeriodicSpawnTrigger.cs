
using UnityEngine;

public class PeriodicSpawnTrigger : MonoBehaviour
{
	public float Period = 0.5f;

	private float Timer = 0f;

	private void Start()
	{
		Spawner spawner = GetComponent<Spawner>();
		spawner.ShouldSpawn = ShouldSpawn;
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
