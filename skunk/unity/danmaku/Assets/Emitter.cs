
using UnityEngine;

public class Emitter : MonoBehaviour
{
	public GameObject Spawnable;
	public float SpawnPeriod = 0.5f;
	public float TimeScale = 1f;
	public float VelocityScale = 1f;
	public bool UseAsSpawnParent = true;

	public delegate Vector3 VelocityDelegate(float t);
	public VelocityDelegate VelocityFunction;

	private float SpawnTimer = 0f;
	private float EmitterAge = 0f;

	private void Update()
	{
		EmitterAge += Time.deltaTime;

		SpawnTimer -= Time.deltaTime;
		if (SpawnTimer <= 0f)
		{
			Spawn();
			SpawnTimer = SpawnPeriod;
		}
	}

	public void Spawn()
	{
		if (Spawnable == null || VelocityFunction == null)
		{
			return;
		}

		// TODO: pool bullets
		GameObject spawnObject = Instantiate(Spawnable);
		if (UseAsSpawnParent)
		{
			spawnObject.transform.parent = transform;
		}

		Bullet bullet = spawnObject.GetComponent<Bullet>();
		bullet.Velocity = VelocityFunction(EmitterAge * TimeScale) * VelocityScale;
	}
}
