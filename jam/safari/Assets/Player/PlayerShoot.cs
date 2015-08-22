using UnityEngine;
using System.Collections;

public class PlayerShoot : MonoBehaviour {
	
	public ParticleSystem FireFX;
	public float ShootRefreshTime = 0.2f;

	private float _ShootElapsed = 0f;

	void Update()
	{
		if (_ShootElapsed < ShootRefreshTime)
		{
			_ShootElapsed += Time.deltaTime;
			return;
		}

		if (Input.GetButtonDown("Fire1") ||
			Input.GetButtonDown("Fire2") ||
			Input.GetButtonDown("Fire3") ||
			Input.GetButtonDown("Jump"))
		{
			TakeShot();
		}
	}

	private void TakeShot()
	{
		_ShootElapsed = 0f;

		if (FireFX != null)
		{
			FireFX.Play();
		}

		RaycastHit hit;
		Transform source = Camera.main.transform;
		if (Physics.Raycast(source.position, source.forward, out hit, 200.0f))
		{
			GameObject hitObject = hit.collider.gameObject;
			if (hitObject.CompareTag("Enemy"))
			{
				hitObject.transform.parent.gameObject.SendMessage("OnShotByPlayer", hit.point);
			}
		}
	}
	
} // class
