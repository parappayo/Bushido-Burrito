﻿using UnityEngine;
using System.Collections;

public class GameState : MonoBehaviour
{
	public GameObject Player;
	public GUIStyle TextStyle;
	
	enum eState
	{
		TITLE,
		TUTORIAL,
		RUNNING,
		LEVEL_COMPLETE,
	}
	
	private eState State;
	
	void Start()
	{
		State = eState.TITLE;
		Player.SetActive(false);
	}
	
	void OnGUI()
	{
		switch (State)
		{
		case eState.TITLE:
		{
			GUI.Label(
				new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
				"BURGER STRIKE\n\nclick to begin",
				TextStyle);
			
			if (Input.GetMouseButtonUp(0))
			{
				State = eState.TUTORIAL;
			}
		}
		break;
			
		case eState.TUTORIAL:
		{
			GUI.Label(
				new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
				"Shoot targets for\nORBITAL STRIKE",
				TextStyle);

			if (Input.GetMouseButtonDown(0))
			{
				State = eState.RUNNING;
				Player.SetActive(true);
			}
		}
		break;

		case eState.RUNNING:
		{
			// TODO: check if all enemies are toast
			bool isComplete = false;

			if (isComplete)
			{
				Player.SetActive(false);
				State = eState.LEVEL_COMPLETE;
			}
		}
		break;
			
		case eState.LEVEL_COMPLETE:
		{
			string caption = string.Format("MISSION ACCOMPLISHED");
			
			GUI.Label(
				new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
				caption,
				TextStyle);
		}
		break;
		} // switch
	}
	
} // class
