using UnityEngine;
using System.Collections;

public class ExplodeOnTouch : MonoBehaviour {

	public GameObject Explosion;

	private Rigidbody _Rigidbody;

	void Start() {

		_Rigidbody = GetComponent<Rigidbody>();
	}

	void Update() {
	
		Vector2 pos = new Vector2();
		if (GetClickPosition(out pos))
		{
			RaycastHit hit;
			if (Physics.Raycast(Camera.main.ScreenPointToRay(pos), out hit))
			{
				if (hit.rigidbody == _Rigidbody)
				{
					Instantiate(Explosion, hit.point, Quaternion.identity);
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
