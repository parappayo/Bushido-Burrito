using UnityEngine;
using System.Collections;

public class Movement : MonoBehaviour {

	public float ForwardSpeed = 20.0f;
	public float LateralSpeed = 10.0f;

	void Start () {
	
	}
	
	void Update () {

		float forward = Input.GetAxis("Vertical") * ForwardSpeed * Time.deltaTime;
		float lateral = Input.GetAxis("Horizontal") * LateralSpeed * Time.deltaTime;
		Vector3 move = new Vector3(lateral, 0, forward);
		transform.position += move;
	}
}
