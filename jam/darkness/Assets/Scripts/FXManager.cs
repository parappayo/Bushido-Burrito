using UnityEngine;
using System.Collections;

public class FXManager : MonoBehaviour {

    public static FXManager Instance { get; private set; }

    public GameObject[] effects;



	void Awake ()
    {
	    Instance = this;
	}
	
	
	public void Spawn (string name, Vector3 position, Quaternion rotation)
    {
	    foreach(GameObject effect in effects)
        {
            if( effect.name == name )
            {
                GameObject newEffect =   Instantiate( effect, position, rotation ) as GameObject;
                newEffect.transform.parent = transform;
                return;
            }
            
        }
        Debug.LogWarning( "[FXManager] Failed to find effect" + name + "." );

	}
}
