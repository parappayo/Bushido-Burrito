using UnityEngine;
using System.Collections;

public class Movement : MonoBehaviour {

	public float ForwardThrust = 20.0f;
	public float LateralThrust = 10.0f;
	public float RotationThrust = 5.0f;

	private Rigidbody _RigidBody;
	private Vector3 _InitialForward;
	private Vector3 _InitialUp;

	void Start() {
	
		_RigidBody = GetComponent<Rigidbody>();
		_InitialForward = transform.forward;
		_InitialUp = transform.up;
	}

	void Update() {

		float timeFactor = Time.deltaTime * 100.0f;
		float forward = Input.GetAxis("Vertical") * ForwardThrust * timeFactor;
		float lateral = Input.GetAxis("Horizontal") * LateralThrust * timeFactor;
		float rotation = Input.GetAxis("Horizontal") * RotationThrust * timeFactor;

		Vector3 thrust = new Vector3(lateral, 0, forward);
		_RigidBody.AddForce(thrust);

		Vector3 torque = new Vector3(0, rotation, 0);
		_RigidBody.AddTorque(torque);

		// maintain upright orientation
		_RigidBody.rotation = Quaternion.Slerp(
			_RigidBody.rotation,
			Quaternion.LookRotation(_InitialForward, _InitialUp),
			Time.deltaTime);
	}
}
