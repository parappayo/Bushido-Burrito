
using UnityEngine;

public class PeriodicEmitter : MonoBehaviour
{
	public float Period = 0.5f;

	private float Timer = 0f;

	private bool Trigger(float t)
	{
		Timer -= t;

		if (Timer <= 0f)
		{
			Timer = Period;
			return true;
		}

		return false;
	}

	private void Start()
	{
		Emitter emitter = GetComponent<Emitter>();
		emitter.TriggerFunction = Trigger;
	}
}
