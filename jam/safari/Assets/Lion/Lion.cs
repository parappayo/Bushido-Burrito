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

	public void Awake()
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
			_Rigidbody.velocity = Vector3.zero;
			_Rigidbody.angularVelocity = Vector3.zero;
		}
	}

	public void OnShotByPlayer(RaycastHit hit)
	{
		HasBeenShot = true;

		if (BloodSplatFX != null)
		{
			BloodSplatFX.transform.position = hit.point;
			BloodSplatFX.transform.forward = hit.normal;
			BloodSplatFX.Play();
		}

		if (_Rigidbody != null)
		{
			// we cheat a little and assume the shot came from the camera facing
			Vector3 impactVector = (Camera.main.transform.forward + transform.up);

			_Rigidbody.AddForce(impactVector * 50f, ForceMode.Impulse);
			_Rigidbody.AddTorque(impactVector * 200f, ForceMode.Impulse);
		}
	}
}
