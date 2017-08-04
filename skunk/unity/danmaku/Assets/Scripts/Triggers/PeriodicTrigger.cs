
using UnityEngine;
using UnityEngine.Events;

public class PeriodicTrigger : MonoBehaviour
{
	public UnityEvent OnTrigger;

	public float TimeScale = 1.0f;
	public float Period = 0.5f;

	private float Timer = 0f;

	private bool Trigger(float t)
	{
		this.Timer -= t;

		if (this.Timer > 0.0f) {
			return false;
		}

		this.Timer = this.Period;
		return true;
	}

	private void FixedUpdate()
	{
		if (Trigger(Time.deltaTime * this.TimeScale)) {
			this.OnTrigger.Invoke();
		}
	}
}
