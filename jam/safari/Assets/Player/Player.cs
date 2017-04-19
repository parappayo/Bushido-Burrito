
using UnityEngine;

public class Player : MonoBehaviour {

	private Vector3 StartingPosition;
	private Quaternion StartingRotation;
	private PlayerShoot Shoot;
	private ResetPosition ResetPosition;
	private Rigidbody Rigidbody;

	public GameObject Rifle;
	public float MinimumAltitude = -10f;

	private void Awake()
	{
		Shoot = GetComponent<PlayerShoot>();
		ResetPosition = GetComponent<ResetPosition>();
		Rigidbody = GetComponent<Rigidbody>();
	}

	private void FixedUpdate()
	{
		if (transform.position.y < MinimumAltitude)
		{
			ResetPosition.Reset();

			if (Rigidbody)
			{
				Rigidbody.velocity = Vector3.zero;
				Rigidbody.angularVelocity = Vector3.zero;
			}
		}
	}

	public void StartAct1()
	{
		ResetPosition.Reset();
		RifleEnabled = true;
	}

	public void StartAct2()
	{
		ResetPosition.Reset();
		RifleEnabled = false;
	}

	private bool RifleEnabled
	{
		set
		{
			Rifle.SetActive(value);
			if (Shoot != null)
			{
				Shoot.enabled = value;
			}
		}
	}
}
