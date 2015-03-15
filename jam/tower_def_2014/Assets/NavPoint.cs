using UnityEngine;
using System.Collections;

public class NavPoint : MonoBehaviour {
	
	public GameObject NextNavPoint;
	
	void OnTriggerEnter(Collider other)
	{
		FollowNavPoints follower = other.GetComponent<FollowNavPoints>();
		if (!follower) { return; }
		follower.CurrentNavPoint = NextNavPoint;
	}
}
