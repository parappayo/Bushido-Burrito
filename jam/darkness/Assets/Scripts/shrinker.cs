using UnityEngine;
using System.Collections;

public class Shrinker : MonoBehaviour 
{
	private ParticleSystem.ShapeModule shape;
	// Use this for initialization
	void Start ()
	{
		shape = this.GetComponent<ParticleSystem>().shape;
	}

	// Update is called once per frame
	void Update () 
	{
		shape.radius -= Time.deltaTime * 0.2f;
	}
}
