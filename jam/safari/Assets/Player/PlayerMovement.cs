
using UnityEngine;

public class PlayerMovement : MonoBehaviour {
	
	public float MovementSpeed;
	public float RotationSpeed;

	private Rigidbody Rigidbody;

	void Start()
	{
		Rigidbody = GetComponent<Rigidbody>();
	}
	
	void Update()
	{
		transform.Rotate(0, Rotation, 0);
		transform.position = transform.position + (transform.rotation * Movement);
	}

	void FixedUpdate()
	{
		if (Rigidbody)
		{
			Rigidbody.angularVelocity = Vector3.zero;
		}
	}

	private Vector3 Movement
	{
		get
		{
			var scale = MovementSpeed * Time.deltaTime;
			return new Vector3(
				0,
				0,
				Input.GetAxis("Vertical") * scale);
		}
	}

	private float Rotation
	{
		get
		{
			var scale = RotationSpeed * Time.deltaTime;
			return Input.GetAxis("Horizontal") * scale;
		}
	}
	
} // class
