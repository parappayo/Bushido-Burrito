
using UnityEngine;

public class FollowCamera : MonoBehaviour
{
	public GameObject Target;
	public Vector3 LookAtOffset;
	public Vector3 CameraRelativePosition;
	//public float SmoothingFactor = 5f;

	private void LateUpdate()
	{
		if (!Target) { return; }

		Vector3 newPosition = Target.transform.position + Target.transform.rotation * CameraRelativePosition;
		//transform.position = Vector3.Lerp(transform.position, newPosition, SmoothingFactor * Time.deltaTime);
		transform.position = newPosition;

		transform.LookAt(Target.transform.position + Target.transform.rotation * LookAtOffset);
	}

}
