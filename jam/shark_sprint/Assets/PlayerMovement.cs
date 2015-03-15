using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour {
	
	public float ForwardSpeed;
	public float MovementSpeed;
	
	public float SwimSlowSpeed;
	public float SwimFastSpeed;

	public float MovementMaxX;
	public float MovementMaxY;
	public float MovementMinX;
	public float MovementMinY;

	private Animation mAnimation;
	private AnimationState mWalkState;
//	private Rigidbody mRigidbody;
	
	void Start()
	{
		mAnimation = GetComponent<Animation>();
		mWalkState = mAnimation["Quick Swim"];
		mWalkState.wrapMode = WrapMode.Loop;
		mAnimation.Play("Quick Swim");

//		mRigidbody = GetComponent<Rigidbody>();
	}
	
	void Update()
	{
		// march toward the finish line
		Vector3 forwardMove = new Vector3(0, 0, 1);
		forwardMove *= ForwardSpeed * Time.deltaTime;
		transform.position += forwardMove;

		// lateral movement
		float scaledMove = MovementSpeed * Time.deltaTime;
		Vector3 movement = new Vector3(
			Input.GetAxis("Horizontal") * scaledMove,
			Input.GetAxis("Vertical") * scaledMove,
			0);

		Vector3 newPos = transform.position + movement;
		newPos.x = Mathf.Max(newPos.x, MovementMinX);
		newPos.y = Mathf.Max(newPos.y, MovementMinY);
		newPos.x = Mathf.Min(newPos.x, MovementMaxX);
		newPos.y = Mathf.Min(newPos.y, MovementMaxY);
		
		transform.position = newPos;

		if (movement.sqrMagnitude > 0.0001)
		{
			mWalkState.speed = SwimFastSpeed;
		}
		else
		{
			mWalkState.speed = SwimSlowSpeed;
		}
	}
	
} // class
