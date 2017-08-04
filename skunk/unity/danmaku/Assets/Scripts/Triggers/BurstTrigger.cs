
using UnityEngine;
using UnityEngine.Events;

public class BurstTrigger : MonoBehaviour
{
	public UnityEvent OnTrigger;

	public float TimeScale = 1.0f;
	public float Period = 0.5f;
	public uint BurstSize = 3;
	public float BurstDuration = 0.3f;

	private float Timer = 0f;
	private bool IsBursting = false;
	private float BurstPeriod;
	private uint BurstRoundsLeft;

	private void Reset()
	{
		this.Timer = this.Period;
		this.IsBursting = false;
	}

	private void StartBurst()
	{
		this.IsBursting = true;
		this.BurstPeriod = this.BurstDuration / (float) this.BurstSize;
		this.BurstRoundsLeft = this.BurstSize - 1;
		this.Timer = this.BurstPeriod;
	}

	private void StartNextBurstRound()
	{
		this.Timer = this.BurstPeriod;
		this.BurstRoundsLeft -= 1;
	}

	private bool Trigger(float t)
	{
		this.Timer -= t;

		if (this.Timer > 0.0f) { return false; }

		if (this.BurstSize < 1) { return false; }

		if (!this.IsBursting) {
			StartBurst();
			return true;
		}

		if (this.BurstRoundsLeft > 1) {
			StartNextBurstRound();
		} else {
			Reset();
		}

		return true;
	}

	private void FixedUpdate()
	{
		if (Trigger(Time.deltaTime * this.TimeScale)) {
			this.OnTrigger.Invoke();
		}
	}
}
