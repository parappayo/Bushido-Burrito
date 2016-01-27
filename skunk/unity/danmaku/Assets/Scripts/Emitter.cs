
using UnityEngine;

public class Emitter : MonoBehaviour
{
	public GameObject Spawnable;
	public bool UseAsSpawnParent = true;

	public float TriggerTimeScale = 1f;

	public float VelocityTimeScale = 1f;
	public float VelocityScale = 1f;
	public Vector3 Acceleration = Vector3.zero;
	public float AccelerationInIntialVelocityDirection = 0f;

	public delegate Vector3 VelocityDelegate(float t);
	public VelocityDelegate VelocityFunction;

	public delegate bool TriggerDelegate(float t);
	public TriggerDelegate TriggerFunction;

	private float EmitterAge = 0f;

	private void Update()
	{
		EmitterAge += Time.deltaTime;

		if (TriggerFunction != null &&
			TriggerFunction(Time.deltaTime * TriggerTimeScale))
		{
			Spawn();
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
		spawnObject.transform.position = transform.position;
		if (UseAsSpawnParent)
		{
			spawnObject.transform.parent = transform;
		}

		Bullet bullet = spawnObject.GetComponent<Bullet>();
		bullet.Velocity = VelocityFunction(EmitterAge * VelocityTimeScale) * VelocityScale;

		bullet.Acceleration = Acceleration + bullet.Velocity * AccelerationInIntialVelocityDirection;
	}
}
