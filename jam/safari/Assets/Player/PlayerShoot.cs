using UnityEngine;
using System.Collections;

public class PlayerShoot : MonoBehaviour {
	
	public ParticleSystem FireFX;

	void Update()
	{
		if (Input.GetButtonDown("Fire1") ||
			Input.GetButtonDown("Fire2") ||
			Input.GetButtonDown("Fire3") ||
			Input.GetButtonDown("Jump"))
		{
			if (FireFX != null)
			{
				FireFX.Play();
			}
		}
	}
	
} // class
