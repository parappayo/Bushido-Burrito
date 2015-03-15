using UnityEngine;
using System.Collections;



public class FollowNavPoints : MonoBehaviour
{
	public GameObject CurrentNavPoint;
	public float Speed;
	

	void Update()
	{
		if (!CurrentNavPoint) { return; }
		
		Vector3 dir = CurrentNavPoint.transform.position - transform.position;
		dir = dir.normalized * Speed;
		transform.LookAt(transform.position + dir);;
		transform.Translate(dir * Time.deltaTime, Space.World);
	}
}

