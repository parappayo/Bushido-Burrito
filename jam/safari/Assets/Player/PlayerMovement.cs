using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour {
	
	public float MovementSpeed;
	public float RotationSpeed;	
	private Rigidbody _Rigidbody;
	
	void Start()
	{
		_Rigidbody = GetComponent<Rigidbody>();
	}
	
	void Update()
	{
		float scaledMove = MovementSpeed * Time.deltaTime;
		float scaledRotate = RotationSpeed * Time.deltaTime;
		
		Vector3 movement = new Vector3(
			0, //Input.GetAxis("Horizontal") * scaledMove,
			0,
			Input.GetAxis("Vertical") * scaledMove);
		
		transform.Rotate(0, Input.GetAxis("Horizontal") * scaledRotate, 0);
		transform.position = transform.position + (transform.rotation * movement);
		
		if (_Rigidbody)
		{
			_Rigidbody.angularVelocity = Vector3.zero;
		}
	}
	
} // class
