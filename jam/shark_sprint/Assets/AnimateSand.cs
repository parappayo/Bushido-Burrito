using UnityEngine;
using System.Collections;

public class AnimateSand : MonoBehaviour
{
	private ProceduralMaterial SandMat;
	
	void Start()
	{
		SandMat = (ProceduralMaterial) renderer.sharedMaterial;
	}
	
	void Update()
	{
		SandMat.SetProceduralFloat("Flow", 0.2f * Time.frameCount);
		SandMat.RebuildTextures();
	}
	
} // class
