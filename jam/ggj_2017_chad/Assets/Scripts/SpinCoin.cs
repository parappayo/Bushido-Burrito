
using UnityEngine;

public class SpinCoin : MonoBehaviour
{
	public float TimeScale = 1.0f;

	private Transform _Transform;

	void Start()
	{
		_Transform = GetComponent<Transform>();
	}

	void FixedUpdate()
	{
		_Transform.Rotate(0.0f, Time.deltaTime * TimeScale, 0.0f);
	}
}
