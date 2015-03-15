using UnityEngine;
using System.Collections;

public class Tower : MonoBehaviour
{
	public float ReloadTime = 3;
	public float AttackDamage = 1;
	
	private float LastAttackTime;
	
	void Start()
	{
		LastAttackTime = Time.time;
	}
	
	void Update()
	{
		if (Time.time - LastAttackTime > ReloadTime)
		{
			Attack();
		}
	}
	
	private void Attack()
	{
		LastAttackTime = Time.time;
		GameObject target = FindNearestCreep();
		if (!target) { return; }
		target.GetComponent<Creep>().TakeDamage(AttackDamage);
	}
	
	private GameObject FindNearestCreep()
	{
		GameObject retval = null;
		float currentDistance = Mathf.Infinity;
		
		GameObject[] creeps = GameObject.FindGameObjectsWithTag("Creep");
		foreach (GameObject creep in creeps)
		{
			float dist = Mathf.Abs(Vector3.Distance(transform.position, creep.transform.position));
			if (dist < currentDistance)
			{
				currentDistance = dist;
				retval = creep;
			}
		}
		
		return retval;
	}
}
