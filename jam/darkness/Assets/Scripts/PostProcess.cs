using UnityEngine;
using System.Collections;

public class PostProcess : MonoBehaviour 
{

	private MeshRenderer meshRenderer;
	private bool outlined;

	//private Shader mainShader;
	// Use this for initialization
	void Start () 
	{
		outlined = false;
		//mainShader = GetComponent<Shader> ();
		meshRenderer = GetComponent<MeshRenderer> ();
	}

	// Update is called once per frame
	void Update () 
	{
	
	}

	public void ToggleOutline()
	{
		if (outlined) 
		{
			meshRenderer.material.shader = Shader.Find("Legacy Shaders/Transparent/Cutout/Diffuse");
			meshRenderer.material.SetInt ("_Mode",1 );
			outlined = false;
		} 
		else 
		{
			meshRenderer.material.shader = Shader.Find("Standard");
			meshRenderer.material.SetInt ("_Mode",1 );
			//meshRenderer.material.SetColor ("_OutlineColor", Color.red);
			//meshRenderer.material.SetFloat ("_Outline", 0.05f);
			outlined = true;
		}

	}
}
