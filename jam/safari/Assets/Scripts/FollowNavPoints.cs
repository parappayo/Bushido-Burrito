using UnityEngine;
using System.Collections;

public class FollowNavPoints : MonoBehaviour {

	public float Speed = 1f;
	public float SmoothingFactor = 5f;
	public GameObject[] NavPoints;

	private int _NavPointIndex;
	private GameObject _CurrentNavPoint;

	public void ResetToFirstNavPoint()
	{
		_NavPointIndex = 0;
		NextNavPoint();
	}

	void OnEnable()
	{
		if (!_CurrentNavPoint)
		{
			NextNavPoint();
		}
	}

	void Update()
	{
		if (DistanceFromNavPointSquared < 1f)
		{
			NextNavPoint();
		}

		if (!_CurrentNavPoint) { return; }

		Vector3 dir = _CurrentNavPoint.transform.position - transform.position;
		Vector3 newPosition = transform.position + (dir.normalized * Speed);
		//transform.position = Vector3.Lerp(transform.position, newPosition, SmoothingFactor * Time.deltaTime);
		transform.position = newPosition;

		Quaternion lookRotation = Quaternion.LookRotation(dir);
		transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, SmoothingFactor * Time.deltaTime);
	}

	private float DistanceFromNavPointSquared
	{
		get
		{
			if (_CurrentNavPoint == null)
			{
				return 100f;
			}

			Vector3 diff = _CurrentNavPoint.transform.position - transform.position;
			return diff.sqrMagnitude;
		}
	}

	private void NextNavPoint()
	{
		if (NavPoints == null || NavPoints.Length < 1)
		{
			_CurrentNavPoint = null;
			return;
		}

		_NavPointIndex = (_NavPointIndex >= 0) ? (_NavPointIndex % NavPoints.Length) : 0;
		_CurrentNavPoint = NavPoints[_NavPointIndex];
		_NavPointIndex++;
	}
}
