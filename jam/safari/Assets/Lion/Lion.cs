using UnityEngine;
using System.Collections;

public class Lion : MonoBehaviour {

	private Rigidbody _Rigidbody;
	private Vector3 StartingPosition;
	private Quaternion StartingRotation;
	public ParticleSystem BloodSplatFX;

	public bool HasBeenShot
	{
		get;
		private set;
	}

	public void Start()
	{
		_Rigidbody = GetComponent<Rigidbody>();
		StartingPosition = transform.position;
		StartingRotation = transform.rotation;
	}

	public void Reset()
	{
		HasBeenShot = false;
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;

		if (_Rigidbody != null)
		{
			_Rigidbody.angularVelocity = Vector3.zero;
		}
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
