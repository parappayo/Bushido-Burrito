
using UnityEngine;

public class Lion : MonoBehaviour {

	public ParticleSystem BloodSplatFX;

	private Rigidbody _Rigidbody;
	private ResetPosition ResetPosition;
	private FollowNavPoints _FollowNavPoints;
	private Spookable Spookable;

	public bool HasBeenShot
	{
		get;
		private set;
	}

	private void Awake()
	{
		_FollowNavPoints = GetComponent<FollowNavPoints>();
		_Rigidbody = GetComponent<Rigidbody>();
		ResetPosition = GetComponent<ResetPosition>();
		Spookable = GetComponent<Spookable>();

		Spookable.OnSpooked = OnSpooked;
		Spookable.OnReset = OnSpookedReset;
	}

	private void Update()
	{
		if (HasBeenShot)
		{
			Spookable.Reset();
		}
	}

	private void OnEnable()
	{
		HasBeenShot = false;
		ResetPosition.Reset();

		if (_Rigidbody != null)
		{
			_Rigidbody.velocity = Vector3.zero;
			_Rigidbody.angularVelocity = Vector3.zero;
			_Rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
		}

		if (_FollowNavPoints != null)
		{
			_FollowNavPoints.ResetToFirstNavPoint();
			_FollowNavPoints.enabled = true;
		}
	}

	public void Spook(Vector3 fromPosition)
	{
		Spookable.Spook(fromPosition);
	}

	public void OnSpooked()
	{
		if (_FollowNavPoints == null) { return; }

		_FollowNavPoints.Speed *= 3f;
	}

	public void OnSpookedReset()
	{
		if (_FollowNavPoints == null) { return; }

		_FollowNavPoints.Speed /= 3f;
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
