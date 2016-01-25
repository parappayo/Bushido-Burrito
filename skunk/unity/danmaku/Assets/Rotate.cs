
using UnityEngine;

public class Rotate : MonoBehaviour
{
	public Vector3 Axis = Vector3.up;
	public float Speed = 10.0f;

	private void Update()
	{
		transform.Rotate(Axis, Speed * Time.deltaTime);
	}
}
