using UnityEngine;
using System.Collections;

public class FollowCamera : MonoBehaviour
{
	public GameObject Target;
//	public Vector3 LookAtOffset;
	public Vector3 CameraRelativePosition;
	
	void LateUpdate()
	{
		if (!Target) { return; }

		// custom version for SharkJam game
		Vector3 pos = new Vector3(
			transform.position.x,
			transform.position.y,
			Target.transform.position.z + CameraRelativePosition.z);
		transform.position = pos;

		// normal camera follow logic
		//transform.position = Target.transform.position;
		//transform.position += Target.transform.rotation * CameraRelativePosition;
		//transform.LookAt(Target.transform.position + LookAtOffset);
	}
	
} // class
