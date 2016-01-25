
using UnityEngine;

public class Bullet : MonoBehaviour
{
	public Vector3 Velocity;
	public float Lifetime = 5f;

	private float LifeTimer = 0f;

	private void Update()
	{
		LifeTimer += Time.deltaTime;
		if (LifeTimer > Lifetime)
		{
			Despawn();
		}

		transform.position += Velocity * Time.deltaTime;
	}

	private void Despawn()
	{
		// TODO: pool bullets
		Destroy(gameObject);
	}
}
