
using UnityEngine;

public class BurstTrigger : MonoBehaviour
{
	public float Period = 0.5f;
	public uint BurstSize = 3;
	public float BurstDuration = 0.3f;

	private float Timer = 0f;
	private bool Bursting = false;
	private float BurstPeriod;
	private uint BurstRoundsLeft;

	private bool Trigger(float t)
	{
		Timer -= t;

		if (Timer <= 0f)
		{
			if (BurstSize < 1)
			{
				return false;
			}

			if (Bursting)
			{
				if (BurstRoundsLeft > 1)
				{
					Timer = BurstPeriod;
					BurstRoundsLeft -= 1;
				}
				else
				{
					Timer = Period;
					Bursting = false;
				}
			}
			else
			{
				BurstPeriod = BurstDuration / (float) BurstSize;
				BurstRoundsLeft = BurstSize - 1;

				Timer = BurstPeriod;
				Bursting = true;
			}

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
