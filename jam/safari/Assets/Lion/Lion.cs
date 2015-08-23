using UnityEngine;
using System.Collections;

public class Lion : MonoBehaviour {

	public ParticleSystem BloodSplatFX;

	private FollowNavPoints _FollowNavPoints;
	private Rigidbody _Rigidbody;
	private Vector3 StartingPosition;
	private Quaternion StartingRotation;

	public bool HasBeenShot
	{
		get;
		private set;
	}

	private bool _HasBeenSpooked;
	public bool HasBeenSpooked
	{
		get
		{
			return _HasBeenSpooked;
		}
		set
		{
			if (value)
			{
				SpookedTimer = 0f;
			}

			if (_HasBeenSpooked == value)
			{
				return;
			}
			_HasBeenSpooked = value;

			if (_FollowNavPoints != null)
			{
				// enable this to instead have lion run in the opposite direction from the player
				//_FollowNavPoints.enabled = !_HasBeenSpooked;

				if (_HasBeenSpooked)
				{
					_FollowNavPoints.Speed *= 3f;
				}
				else
				{
					_FollowNavPoints.Speed /= 3f;					
				}
			}
		}
	}
	public float SpookedTimeout = 5f;
	private float SpookedTimer;
	public float SpookedSpeed = 0.3f;
	public Vector3 SpookedDirection;

	public void Awake()
	{
		_FollowNavPoints = GetComponent<FollowNavPoints>();
		_Rigidbody = GetComponent<Rigidbody>();
		StartingPosition = transform.position;
		StartingRotation = transform.rotation;
		HasBeenSpooked = false;
	}

	public void Update()
	{
		if (HasBeenShot)
		{
			HasBeenSpooked = false;
		}
		else if (HasBeenSpooked)
		{
			SpookedTimer += Time.deltaTime;

			if (SpookedTimer >= SpookedTimeout)
			{
				HasBeenSpooked = false;
			}
			else if (!_FollowNavPoints.enabled)
			{
				if (SpookedDirection.sqrMagnitude < 1f)
				{
					HasBeenSpooked = false;
				}
				else
				{
					transform.position = transform.position + (SpookedDirection.normalized * SpookedSpeed);
					Quaternion lookRotation = Quaternion.LookRotation(SpookedDirection);
					transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, 1.5f * Time.deltaTime);
				}
			}
		}
	}

	public void Reset()
	{
		HasBeenShot = false;
		transform.position = StartingPosition;
		transform.rotation = StartingRotation;

		HasBeenSpooked = false;

		if (_Rigidbody != null)
		{
			_Rigidbody.velocity = Vector3.zero;
			_Rigidbody.angularVelocity = Vector3.zero;
			_Rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
		}

		if (_FollowNavPoints != null)
		{
			_FollowNavPoints.enabled = true;
		}
	}

	public void OnShotByPlayer(RaycastHit hit)
	{
		HasBeenShot = true;

		if (_FollowNavPoints != null)
		{
			_FollowNavPoints.enabled = false;
		}

		if (BloodSplatFX != null)
		{
			BloodSplatFX.transform.position = hit.point;
			BloodSplatFX.transform.forward = hit.normal;
			BloodSplatFX.Play();
		}

		if (_Rigidbody != null)
		{
			_Rigidbody.constraints = RigidbodyConstraints.None;

			// we cheat a little and assume the shot came from the camera facing
			Vector3 impactVector = (Camera.main.transform.forward + transform.up);

			_Rigidbody.AddForce(impactVector * 50f, ForceMode.Impulse);
			_Rigidbody.AddTorque(impactVector * 200f, ForceMode.Impulse);
		}
	}
}
