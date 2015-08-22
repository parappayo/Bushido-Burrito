using UnityEngine;
using System.Collections;

public class Player : MonoBehaviour {

	private Vector3 StartingPosition;
	private Quaternion StartingRotation;
	private PlayerShoot Shoot;

	public GameObject Rifle;

	public void Reset()
	{
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;
	}

	public void StartAct1()
	{
		StartingPosition = transform.position;
		StartingRotation = transform.rotation;
		Shoot = GetComponent<PlayerShoot>();

		Rifle.SetActive(true);
		Shoot.enabled = true;
	}

	public void StartAct2()
	{
		Reset();
		Rifle.SetActive(false);
		Shoot.enabled = false;
	}
}
