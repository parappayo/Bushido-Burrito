
using UnityEngine;

public class Bullet : MonoBehaviour
{
	public Vector3 Velocity = Vector3.zero;
	public Vector3 Acceleration = Vector3.zero;
	public bool UseLocalVelocity = true;
	public float Lifetime = 5f;

	private float LifeTimer = 0f;

	private void Update()
	{
		LifeTimer += Time.deltaTime;
		if (LifeTimer > Lifetime)
		{
			Despawn();
		}

		Velocity += Acceleration * Time.deltaTime;

		if (UseLocalVelocity)
		{
			transform.localPosition += Velocity * Time.deltaTime;
		}
		else
		{
			transform.position += Velocity * Time.deltaTime;
		}
	}

	private void Despawn()
	{
		// TODO: pool bullets
		Destroy(gameObject);
	}
}
