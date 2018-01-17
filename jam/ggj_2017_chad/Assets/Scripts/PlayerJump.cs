
using System;
using UnityEngine;

public class PlayerJump : MonoBehaviour
{
	public Vector3 Force = new Vector3(0f, 1f, 0f);
	public Vector3 ExtraDrag = Vector3.zero;
	public string Button = "Jump";
	public string Button2 = "Fire2";
	public AudioClip[] JumpSounds;

	private Rigidbody _Rigidbody;
	private CapsuleCollider _Collider;
	private AudioSource _AudioSource;
	private System.Random _Random = new System.Random();
	private int LastUsedSoundIndex = -1;
    private Animator _Animator;

    private void Start()
	{
		_Rigidbody = GetComponent<Rigidbody>();
		_Collider = GetComponent<CapsuleCollider>();
		_AudioSource = GetComponent<AudioSource>();

        _Animator = GetComponent<Animator>();
    }

	private void FixedUpdate()
	{
		// kludge to account for the weird gravity scale
		_Rigidbody.velocity = _Rigidbody.velocity + ExtraDrag * Time.deltaTime;

		bool jumpButtonPressed = Input.GetButtonDown(Button) || Input.GetButtonDown(Button2);
		if (jumpButtonPressed && IsGrounded)
		{
			Jump();
			PlayJumpSound();
		}

        _Animator.SetBool("jumping", !IsGrounded);
    }

	private bool IsGrounded
	{
		get
		{
			//return Physics.Raycast(transform.position, -Vector3.up, _Collider.bounds.extents.y - 0.02f);

			 var colliderStart = _Collider.bounds.center;
			 var colliderEnd = new Vector3(_Collider.bounds.center.x, _Collider.bounds.min.y - 0.1f, _Collider.bounds.center.z);
			 int platformLayer = 1 << 8;

			 bool result = Physics.CheckCapsule(
			 	colliderStart,
			 	colliderEnd,
			 	_Collider.radius,
                 platformLayer,
				QueryTriggerInteraction.Ignore);
			return result;
		}
	}

	private void Jump()
	{
		_Rigidbody.velocity = Vector3.zero;
		_Rigidbody.angularVelocity = Vector3.zero;
		_Rigidbody.AddForce(Force, ForceMode.Impulse);
	}

	private void PlayJumpSound()
	{
		int soundCount = JumpSounds.Length;
		if (soundCount > 0)
		{
			int randIndex = _Random.Next(0, soundCount);
			if (randIndex == LastUsedSoundIndex)
			{
				randIndex = (randIndex + 1) % soundCount;
			}

			var sound = JumpSounds[randIndex];
			_AudioSource.PlayOneShot(sound);
		}
	}
}
