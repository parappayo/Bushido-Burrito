
using UnityEngine;

public class WavePath : MonoBehaviour
{
	private Vector3 Velocity(float t)
	{
		return new Vector3(Mathf.Sin(t), -1f, 0f);
	}

	private void Start()
	{
		Emitter emitter = GetComponent<Emitter>();
		emitter.VelocityFunction = Velocity;
	}
}
