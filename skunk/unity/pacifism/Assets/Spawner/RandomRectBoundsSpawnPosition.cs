
using UnityEngine;

public class RandomRectBoundsSpawnPosition : MonoBehaviour
{
	public Vector3 Min;
	public Vector3 Max;

	private void Start()
	{
		Spawner spawner = GetComponent<Spawner>();
		spawner.SpawnPosition = SpawnPosition;
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
