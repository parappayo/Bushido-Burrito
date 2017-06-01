
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

	private void OnEnable()
	{
		this.Triggered = false;
	}

	private void Update()
	{
		if (!this.Triggered) { return; }

		this.TriggerDelayCounter += Time.deltaTime;
		if (this.TriggerDelayCounter > this.TriggerDelaySecs)
		{
			Explode();
		}
	}

	public void Trigger()
	{
		this.Triggered = true;
		this.TriggerDelayCounter = 0.0f;
	}

	public void Explode()
	{
		foreach (Transform target in TargetsParent.transform)
		{
			if (!target.gameObject.activeSelf) { continue; }

			if (IsInBlastRadius(target))
			{
				target.SendMessage("ExplosionHit", gameObject);
			}
		}

		if (DestroyWhenFinished)
		{
			Poolable.Destroy(this.gameObject);
		}
	}

	public bool IsInBlastRadius(Transform target)
	{
		var distanceToTarget = Math.Abs(Vector3.Distance(target.transform.position, transform.position));
		return distanceToTarget < this.BlastRadius;
	}
}
