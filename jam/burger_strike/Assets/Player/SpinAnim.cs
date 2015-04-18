using UnityEngine;
using System.Collections;

public class SpinAnim : MonoBehaviour {

	public GameObject Target;
	public Vector3 Axis = Vector3.up;
	public float Speed = 10.0f;

	void Update () {
		Target.transform.Rotate(Axis, Speed * Time.deltaTime);
	}
}
