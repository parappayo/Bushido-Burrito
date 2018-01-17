
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
	public float Speed = 1f;
	public string Axis = "Horizontal";

	/// <summary>
	/// Reference to the <see cref="UnityEngine.Transform"/> used for the player's 3D model. Set this in the editor.
	/// </summary>
	public Transform ModelTransform = null;

	#pragma warning disable 0414
	private Rigidbody _Rigidbody;
	#pragma warning restore 0414

    private Animator _Animator;

	private Vector3 _OldMoveDirection = new Vector3(1f, 0f, 0f);

	private void Start()
	{
		#pragma warning disable 0414
		_Rigidbody = GetComponent<Rigidbody>();
		#pragma warning restore 0414

        _Animator  = GetComponent<Animator>();
	}

	private void FixedUpdate()
	{
		var moveDirection = MoveDirection;
		transform.position = transform.position + moveDirection;

		if (moveDirection != Vector3.zero)
		{
			ModelTransform.forward = Vector3.Normalize(moveDirection);
			_OldMoveDirection = moveDirection;
		}
		else if (_OldMoveDirection != Vector3.zero)
		{
			ModelTransform.forward = _OldMoveDirection;
		}
	}

    private void Update()
    {
        _Animator.SetBool("running", Mathf.Abs(MoveDirection.x) > 0.001f);
    }

	private Vector3 MoveDirection
	{
		get
		{
			var scale = Speed + Time.deltaTime;
			return new Vector3(
				Input.GetAxis(Axis) * scale,
				0f,
				0f);
		}
	}
}
