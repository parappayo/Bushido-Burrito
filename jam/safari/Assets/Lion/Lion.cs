using UnityEngine;
using System.Collections;

public class Lion : MonoBehaviour {

	public ParticleSystem BloodSplatFX;

	public bool HasBeenShot
	{
		private set;
		get;
	}

	public void OnShotByPlayer(Vector3 hitPoint)
	{
		HasBeenShot = true;

		if (BloodSplatFX != null)
		{
			BloodSplatFX.transform.position = hitPoint;
			BloodSplatFX.Play();
		}
	}
}
