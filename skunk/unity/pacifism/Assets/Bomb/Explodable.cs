
using System;

using UnityEngine;

public class Explodable : MonoBehaviour
{
	public GameObject TargetsParent;

	public bool DestroyWhenFinished = true;

	public float BlastRadius = 1.0f;

	public float TriggerDelaySecs = 2.0f;

	private bool Triggered = false;

	private float TriggerDelayCounter = 0.0f;

	public void Update()
	{
		if (!Triggered) { return; }

		TriggerDelayCounter += Time.deltaTime;
		if (TriggerDelayCounter > TriggerDelaySecs)
		{
			Explode();
		}
	}

	public void Trigger()
	{
		Triggered = true;
		TriggerDelayCounter = 0.0f;
	}

	public void Explode()
	{
		foreach (Transform target in TargetsParent.transform)
		{
			if (IsInBlastRadius(target))
			{
				target.SendMessage("ExplosionHit", gameObject);
			}
		}

		if (DestroyWhenFinished)
		{
			Destroy(gameObject);
		}
	}

	public bool IsInBlastRadius(Transform target)
	{
		var distanceToTarget = Math.Abs(Vector3.Distance(target.transform.position, transform.position));
		return distanceToTarget < BlastRadius;
	}
}
