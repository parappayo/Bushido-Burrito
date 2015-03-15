using UnityEngine;
using System.Collections;

public class PlayerLogic : MonoBehaviour
{
	public float SpeedBoost;
	public float SpeedDecay;
	
	private float Speed;
	private float MinSpeed;
	private float MinLateralSpeed;
	
	PlayerMovement Movement;
	
	void Start()
	{
		Movement = GetComponent<PlayerMovement>();
		MinSpeed = Movement.ForwardSpeed;
		Speed = Movement.ForwardSpeed;
		MinLateralSpeed = Movement.MovementSpeed;
	}
	
	void Update()
	{
		Speed -= SpeedDecay * Time.deltaTime;
		Speed = Mathf.Max(Speed, MinSpeed);
		Movement.ForwardSpeed = Speed;
		Movement.MovementSpeed = Mathf.Max(Speed * 0.5f, MinLateralSpeed);
	}
	
	void OnTriggerEnter(Collider collider)
	{
		Speed += SpeedBoost;
		
		collider.gameObject.renderer.enabled = false;
	}
	
	public void Reset()
	{
		Speed = MinSpeed;
		Movement.ForwardSpeed = MinSpeed;
		Movement.MovementSpeed = MinLateralSpeed;
	}
	
} // class
