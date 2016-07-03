
using System;
using UnityEngine;

public class Spookable : MonoBehaviour
{
	public float Timeout = 5f;
	private float Timer;

	public float Speed = 0.3f;

	public Action OnSpooked;
	public Action OnReset;

	private void OnEnable()
	{
		_IsSpooked = false;
	}

	private void Update()
	{
		if (!IsSpooked) { return; }

		Timer += Time.deltaTime;
		if (Timer >= Timeout)
		{
			Reset();
		}
	}

	private Vector3 _Direction = Vector3.zero;
	public Vector3 Direction
	{
		get
		{
			return _Direction * Speed;
		}
	}

	private bool _IsSpooked = false;
	public bool IsSpooked
	{
		get { return _IsSpooked; }
	}

	public void Spook(Vector3 fromPosition)
	{
		Timer = 0f;

		if (_IsSpooked) { return; }
		_IsSpooked = true;

		_Direction = transform.position - fromPosition;
		_Direction.y = 0f;
		_Direction.Normalize();

		if (OnSpooked != null)
		{
			OnSpooked();
		}
	}

	public void Reset()
	{
		if (!_IsSpooked) { return; }
		_IsSpooked = false;

		if (OnReset != null)
		{
			OnReset();
		}
	}

} // class
