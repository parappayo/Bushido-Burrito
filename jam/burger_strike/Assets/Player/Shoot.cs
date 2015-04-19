using UnityEngine;
using System.Collections;

public class Shoot : MonoBehaviour {

	public GameObject Explosion;
	public float ShootRefreshTime = 0.2f;

	private float _ShootElapsed = 0.0f;

	void Update() {

		if (_ShootElapsed < ShootRefreshTime)
		{
			_ShootElapsed += Time.deltaTime;
			return;
		}
	
		if (Input.GetButtonDown("Fire1") ||
		    Input.GetButtonDown("Jump"))
		{
			TakeShot();
		}
	}

	void TakeShot() {

		_ShootElapsed = 0.0f;

		RaycastHit hit;
		if (Physics.Raycast(transform.position, transform.up, out hit, 200.0f))
		{
			Instantiate(Explosion, hit.point, Quaternion.identity);

			if (hit.collider.gameObject.CompareTag("Enemy"))
			{
				hit.collider.gameObject.SendMessage("Strike");
			}
		}
	}
}
