using UnityEngine;
using System.Collections;

public class RitualCircle : MonoBehaviour {

	Craftable objectA = null;
	Craftable objectB = null;
	Craftable objectC = null;

	Collectable[] A = null;
	Collectable[] B = null;
	Collectable[] C = null;

	/*
	 * A[0] must match C[2]
	 * A[2] must match B[0]
	 * B[2] must match C[0]
	 * A[1] B[1] and C[1] can be any ingredient contained in their corresponding craftable
	 * All ingredients can only be used once
	 */

	public void Summon()
	{
		//this assumes that the drag and drop system does not allow multiple items of the same type to be added
		if( A[0] == C[2] && A[2] == B[0] && B[2] == C[0] )
		{
			if( (A[1].m_ItemType & objectA.m_ItemType) != 0 && 
				(B[1].m_ItemType & objectB.m_ItemType) != 0 && 
				(C[1].m_ItemType & objectC.m_ItemType) != 0)
			{
				//the pattern is met, success... summon an angel
			}
		}
		//the pattern is not met, failure... summon a demon
	}

	// Use this for initialization
	void Start () 
	{
		A = new Collectable[3];
		B = new Collectable[3];
		C = new Collectable[3];
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
