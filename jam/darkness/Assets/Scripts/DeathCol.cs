using UnityEngine;
using System.Collections;

public class DeathCol : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnCollisionEnter (Collision col)
	{
		Debug.Log ("Collision Death");
		if(col.gameObject.name == "Character")
		{
			Application.LoadLevel("DemoPlayScene");
		}
	}
}
