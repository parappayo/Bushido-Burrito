using UnityEngine;
using System.Collections;

public class GameState : MonoBehaviour
{
	public GameObject Player;
	public GameObject Pickups;
	public float FinishLine;
	public GUIStyle TextStyle;
	
	private Vector3 StartingPosition;
	private float StartTime;
	private float FinishTime;
	
	enum eState
	{
		READY_TO_START,
		RUNNING,
		LEVEL_COMPLETE,
	}
	
	private eState State;
	
	void Start()
	{
		State = eState.READY_TO_START;
		Player.SetActive(false);
		StartingPosition = Player.transform.position;
	}
	
	void OnGUI()
	{
		switch (State)
		{
			case eState.READY_TO_START:
			{
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					"SHARK SPRINT\n\nclick to begin",
					TextStyle);
			
				if (Input.GetMouseButtonUp(0))
				{
					State = eState.RUNNING;
					Player.SetActive(true);
					Pickups.GetComponent<PickupSpawner>().Reset();
					StartTime = Time.time;
				}
			}
			break;
			
			case eState.RUNNING:
			{
				if (Player.transform.position.z > FinishLine)
				{
					Player.SetActive(false);
					FinishTime = Time.time;
					State = eState.LEVEL_COMPLETE;
				}
			}
			break;
			
			case eState.LEVEL_COMPLETE:
			{
				string caption = string.Format("Your Time: {0:n2}\n\nclick to try again", FinishTime - StartTime);
			
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					caption,
					TextStyle);				

				if (Input.GetMouseButtonUp(0))
				{
					Player.transform.position = StartingPosition;
					Player.SetActive(true);
					Player.GetComponent<PlayerLogic>().Reset();
					Pickups.GetComponent<PickupSpawner>().Reset();
					StartTime = Time.time;

					State = eState.RUNNING;
				}
			}
			break;
		}
	}
	
} // class
