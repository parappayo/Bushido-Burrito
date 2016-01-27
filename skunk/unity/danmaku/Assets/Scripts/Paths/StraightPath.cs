
using UnityEngine;

public class StraightPath : MonoBehaviour
{
	public Vector3 Direction = new Vector3(0f, -1f, 0f);

	private Vector3 Velocity(float t)
	{
		return Direction;
	}

	private void Start()
	{
		Emitter emitter = GetComponent<Emitter>();
		emitter.VelocityFunction = Velocity;
	}
}
