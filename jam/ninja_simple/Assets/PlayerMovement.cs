using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour {
	
	public float MovementSpeed;
	public float RotationSpeed;
	public float WalkAnimSpeed;
	public float JumpForce;
	
	private Animation mAnimation;
	private AnimationState mWalkState;
	private Rigidbody mRigidbody;
	
	private bool mIsJumping; // or falling
	
	void Start()
	{
		mAnimation = GetComponent<Animation>();
		mWalkState = mAnimation["walk"];
		mWalkState.wrapMode = WrapMode.Loop;

		mRigidbody = GetComponent<Rigidbody>();
		
		mIsJumping = false;
	}
	
	void Update()
	{
		if (mIsJumping)
		{
			if (mRigidbody.velocity.y > 0.01)
			{
				mAnimation.Play("jump");
			}
			else if (Mathf.Abs(mRigidbody.velocity.y) < 0.5)
			{
				mIsJumping = false;
			}
			else
			{
				mAnimation.Play("jumpfall");
			}
			return;
		}
		else if (mRigidbody.velocity.y < -1)
		{
			// fall starts here
			mIsJumping = true;
			mAnimation.Play("jumpfall");
			return;
		}
		
		float scaledMove = MovementSpeed * Time.deltaTime;
		float scaledRotate = RotationSpeed * Time.deltaTime;
		
		Vector3 movement = new Vector3(
			0, //Input.GetAxis("Horizontal") * scaledMove,
			0,
			Input.GetAxis("Vertical") * scaledMove);
		
		if (mRigidbody.velocity.y > 1)
		{
			mIsJumping = true;
			return;
		}		
		else if (Input.GetButtonDown("Jump"))
		{
			movement.Normalize();
			movement.y = 1;
			mRigidbody.AddForce(transform.rotation * movement * JumpForce, ForceMode.Impulse);
			
			//mRigidbody.AddForce(0, JumpForce, 0, ForceMode.Impulse);
			return;
		}
		
		//mRigidbody.AddTorque(0, Input.GetAxis("Camera") * scaledRotate, 0, ForceMode.Impulse);
		
		transform.Rotate(0, Input.GetAxis("Horizontal") * scaledRotate, 0);
		transform.position = transform.position + (transform.rotation * movement);
		
		if (movement.sqrMagnitude > 0.0001)
		{
			mWalkState.speed = movement.z * WalkAnimSpeed;
			mAnimation.Play("walk");
		}
		else
		{
			mAnimation.Play("idle");
		}
	}
	
} // class
