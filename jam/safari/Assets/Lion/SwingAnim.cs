using UnityEngine;
using System.Collections;

public class SwingAnim : MonoBehaviour {

	public Vector3 RotationAxis;
	public float RotationSpeed = 1f;
	public float RotationOffset = 0f;
	public float TimeOffset = 0f;

	void Update()
	{
		float rotationDegrees = RotationOffset + Mathf.Sin((Time.time + TimeOffset) * RotationSpeed) * (180f / Mathf.PI);
		transform.localRotation = Quaternion.AngleAxis(rotationDegrees, RotationAxis);
	}
}
