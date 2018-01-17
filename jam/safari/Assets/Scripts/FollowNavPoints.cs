using UnityEngine;
using System.Collections;

public class FollowNavPoints : MonoBehaviour
{
	public float Speed = 1f;
	public float SmoothingFactor = 5f;
	public GameObject[] NavPoints;
	public float NavPointReachedDistance = 1f;

	private uint NavPointIndex = 0;

	public void ResetToFirstNavPoint()
	{
		NavPointIndex = 0;
	}

	private void StartNextNavPoint()
	{
		NavPointIndex = (NavPointIndex + 1) % (uint) NavPoints.Length;
	}

	private GameObject CurrentNavPoint
	{
		get { return NavPoints[NavPointIndex]; }
	}

	private void Update()
	{
		Vector3 dir = CurrentNavPoint.transform.position - transform.position;

		MoveToward(dir);
		LookToward(dir);

		if (HasReachedNavPoint(dir))
		{
			StartNextNavPoint();
		}
	}

	private void MoveToward(Vector3 dir)
	{
		Vector3 newPosition = transform.position + (dir.normalized * Speed * Time.deltaTime);
		//transform.position = Vector3.Lerp(transform.position, newPosition, SmoothingFactor * Time.deltaTime);
		transform.position = newPosition;
	}

	private void LookToward(Vector3 dir)
	{
		Quaternion lookRotation = Quaternion.LookRotation(dir);
		transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, SmoothingFactor * Time.deltaTime);
	}

	private void HasReachedNavPoint(Vector3 dir)
	{
		return dir.sqrMagnitude < NavPointReachedDistance * NavPointReachedDistance;
	}
}
