
using UnityEngine;

public class SpiralEmitter : MonoBehaviour
{
	private Vector3 Velocity(float t)
	{
		return new Vector3(Mathf.Sin(t), Mathf.Cos(t), 0f);
	}

	private void Start()
	{
		Emitter emitter = GetComponent<Emitter>();
		emitter.VelocityFunction = Velocity;
	}
}
