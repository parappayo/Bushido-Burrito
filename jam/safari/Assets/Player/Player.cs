using UnityEngine;
using System.Collections;

public class Player : MonoBehaviour {

	private Vector3 StartingPosition;
	private Quaternion StartingRotation;
	private PlayerShoot Shoot;

	public GameObject Rifle;

	public void Awake()
	{
		StartingPosition = transform.position;
		StartingRotation = transform.rotation;
		Shoot = GetComponent<PlayerShoot>();
	}

	public void Update()
	{
		// fall through the world catch
		if (transform.position.y < -10f)
		{
			transform.position = StartingPosition;
			transform.rotation = StartingRotation;
		}
	}

	public void StartAct1()
	{
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;

		Rifle.SetActive(true);
		Shoot.enabled = true;
	}

	public void StartAct2()
	{
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;

		Rifle.SetActive(false);
		if (Shoot != null)
		{
			Shoot.enabled = false;
		}
	}
}
