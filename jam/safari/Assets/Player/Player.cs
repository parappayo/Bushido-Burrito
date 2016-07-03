
using UnityEngine;

public class Player : MonoBehaviour {

	private Vector3 StartingPosition;
	private Quaternion StartingRotation;
	private PlayerShoot Shoot;

	public GameObject Rifle;
	public float MinimumAltitude = -10f;

	public void Awake()
	{
		StartingPosition = transform.position;
		StartingRotation = transform.rotation;
		Shoot = GetComponent<PlayerShoot>();
	}

	public void Update()
	{
		if (transform.position.y < MinimumAltitude)
		{
			ResetPosition();
		}
	}

	public void StartAct1()
	{
		ResetPosition();
		RifleEnabled = true;
	}

	public void StartAct2()
	{
		ResetPosition();
		RifleEnabled = false;
	}

	private void ResetPosition()
	{
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;
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
