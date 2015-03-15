using UnityEngine;
using System.Collections;

public class FollowCamera : MonoBehaviour
{
	public GameObject Target;
	public Vector3 LookAtOffset;
	public Vector3 CameraRelativePosition;
	
	void LateUpdate()
	{
		if (!Target) { return; }
		
		transform.position = Target.transform.position;
		transform.position += Target.transform.rotation * CameraRelativePosition;
		
		transform.LookAt(Target.transform.position + LookAtOffset);
	}
	
} // class
