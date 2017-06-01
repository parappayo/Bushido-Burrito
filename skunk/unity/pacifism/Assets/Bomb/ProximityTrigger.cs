
using System;

using UnityEngine;
using UnityEngine.Events;

public class ProximityTrigger : MonoBehaviour
{
	public GameObject Target;

	public float ProximityThreshold = 1.0f;

	public UnityEvent Callback;

	public bool Triggered = false;

	public void Update()
	{
		if (Triggered || Target == null) { return; }

		if (DistanceToTarget < ProximityThreshold)
		{
			Triggered = true;

			if (Callback != null) { Callback.Invoke(); }
		}
	}

	public float DistanceToTarget
	{
		get
		{
			return Math.Abs(Vector3.Distance(Target.transform.position, transform.position));
		}
	}
}
