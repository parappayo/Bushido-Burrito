﻿using UnityEngine;
using System.Collections;

public class Act1Logic : MonoBehaviour {

	public GameObject Act2;
	public Player ThePlayer;
	public Lion TheLion;
	public float IntroCaptionTimeout = 3.5f;
	public float OutroCaptionTimeout = 3.5f;
	public GUIStyle TextStyle;

	private Flow _Flow;

	void OnEnable()
	{
		_Flow = new Flow();
		_Flow.OnEnterState += new StateChangedHandler(OnEnterState);
		_Flow.OnExitState += new StateChangedHandler(OnExitState);
		_Flow.State = Flow.eState.INTRO;

		if (Act2 != null)
		{
			Act2.SetActive(false);
		}

		if (ThePlayer != null)
		{
			ThePlayer.StartAct1();
		}
	}

	void OnDisable()
	{
		_Flow.State = Flow.eState.IDLE;
		_Flow.OnEnterState -= new StateChangedHandler(OnEnterState);
		_Flow.OnExitState -= new StateChangedHandler(OnExitState);

		if (TheLion != null)
		{
			TheLion.Reset();
		}

		if (Act2 != null)
		{
			Act2.SetActive(true);
		}
	}

	void Update()
	{
		_Flow.Update(Time.deltaTime);

		switch (_Flow.State)
		{
			case Flow.eState.INTRO:
				if (_Flow.StateTimer >= IntroCaptionTimeout)
				{
					_Flow.State = Flow.eState.NORMAL;
				}
				break;

			case Flow.eState.NORMAL:
				if (TheLion != null &&
					TheLion.HasBeenShot)
				{
					_Flow.State = Flow.eState.OUTRO;
				}
				break;

			case Flow.eState.OUTRO:
				if (_Flow.StateTimer >= OutroCaptionTimeout)
				{
					_Flow.State = Flow.eState.IDLE;
				}
				break;
		}
	}

	private float CaptionAlpha
	{
		get
		{
			return TextStyle.normal.textColor.a;
		}
		set
		{
			Color c = TextStyle.normal.textColor;
			c.a = value;
			TextStyle.normal.textColor = c;
		}
	}

	void OnGUI()
	{
		switch (_Flow.State)
		{
			case Flow.eState.INTRO:
				CaptionAlpha = Mathf.Clamp01(IntroCaptionTimeout * (IntroCaptionTimeout - _Flow.StateTimer) / IntroCaptionTimeout);
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					"SAFARI",
					TextStyle);
				break;

			case Flow.eState.OUTRO:
				CaptionAlpha = Mathf.Clamp01(OutroCaptionTimeout * (OutroCaptionTimeout - _Flow.StateTimer) / OutroCaptionTimeout);
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					"NICE KILL",
					TextStyle);
				break;
		}
	}

	private void OnEnterState(Flow flow, Flow.eState oldState, Flow.eState newState)
	{
		switch (newState)
		{
			case Flow.eState.IDLE:
				gameObject.SetActive(false);
				break;
		}
	}

	private void OnExitState(Flow flow, Flow.eState oldState, Flow.eState newState)
	{

	}
}
