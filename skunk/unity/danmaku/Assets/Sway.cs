
using UnityEngine;

public class Sway : MonoBehaviour
{
	public Vector3 Magnitude = Vector3.zero;
	public float Speed = 1f;

	private Vector3 PreviousOffset = Vector3.zero;
	private float LifeTimer = 0f;

	private void Update()
	{
		LifeTimer += Time.deltaTime;

		Vector3 offset = Magnitude * (Mathf.Sin(LifeTimer) * Speed);
		transform.position = transform.position + (offset - PreviousOffset);
		PreviousOffset = offset;
	}
}
