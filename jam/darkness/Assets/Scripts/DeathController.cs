using UnityEngine;
using System.Collections;

public class DeathController : MonoBehaviour 
{


	public ParticleSystem particle;
	public Transform charTrans;
	public Transform rayTrans;
	private NavMeshAgent agent;

	private float spawnRadius;
	private float attackRadius;
	private Vector3 warpos;

	private bool teleported = false;
	// Use this for initialization
	void Start ()
	{
		agent = GetComponent<NavMeshAgent> ();
		spawnRadius = particle.shape.radius-10;
		attackRadius = particle.shape.radius -  30 ;
	}
		
	// Update is called once per frame
	void Update () 
	{
		spawnRadius = particle.shape.radius-10;
		attackRadius = particle.shape.radius - 30 ;

		if (charTrans.position.magnitude > attackRadius)
		{
			Vector3 newPos = charTrans.position;
			newPos.Normalize ();
			newPos *= spawnRadius;
			newPos.y = 1;
			NavMeshHit hit;
			agent.Raycast (newPos, out hit);
			agent.Warp (hit.position);

			if(agent.isOnNavMesh)
			{
				agent.Raycast (charTrans.position, out hit);
				agent.SetDestination (hit.position);
			}
			teleported = false;
		}
		else if (!teleported) 
		{
			FXManager.Instance.Spawn ("DeathVanish", transform.position, transform.rotation);
			NavMeshHit hit;
			agent.Raycast ((new Vector3 (1, 0, 1) * spawnRadius)  + new Vector3(0,1,0), out hit);
			warpos = hit.position;
			Invoke ("DelayedWarp", 1);
			teleported = true;

		}
		else if (charTrans.position.magnitude < attackRadius) 
		{
			Vector3 temp = charTrans.position; 
			agent.SetDestination (temp.normalized * spawnRadius);
		}
	}


	void DelayedWarp()
	{
		agent.Warp (warpos);
	}



}
