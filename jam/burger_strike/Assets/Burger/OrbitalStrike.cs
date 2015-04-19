using UnityEngine;
using System.Collections;

public class OrbitalStrike : MonoBehaviour {
	
	public GameObject SpawnObject;
	public Vector3 SpawnOffset;
	
	private Rigidbody _Rigidbody;
	private bool _AlreadySpawned;
	
	void Start() {
		
		_Rigidbody = GetComponent<Rigidbody>();
		_AlreadySpawned = false;
	}
	
	void Update() {

		if (_AlreadySpawned) { return; }

		Vector2 pos = new Vector2();
		if (GetClickPosition(out pos))
		{
			RaycastHit hit;
			if (Physics.Raycast(Camera.main.ScreenPointToRay(pos), out hit))
			{
				if (hit.rigidbody == _Rigidbody)
				{
					_AlreadySpawned = true;
					Instantiate(
						SpawnObject,
						hit.point + SpawnOffset,
						Quaternion.LookRotation(Vector3.up, Vector3.forward));
				}
			}
		}
	}
	
	bool GetClickPosition(out Vector2 pos)
	{
		if (Input.touchCount > 0)
		{
			pos = Input.touches[0].position;
			return true;
		}
		if (Input.GetMouseButtonDown(0))
		{
			pos = Input.mousePosition;
			return true;
		}
		
		pos = Vector2.zero;
		return false;
	}
}
