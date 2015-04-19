using UnityEngine;
using System.Collections;

public class DespawnTimer : MonoBehaviour {

	public float Lifetime = 5.0f;
	private float _Elapsed = 0.0f;

	void Update() {
	
		_Elapsed += Time.deltaTime;
		if (_Elapsed > Lifetime)
		{
			Destroy(gameObject);
		}
	}
}
