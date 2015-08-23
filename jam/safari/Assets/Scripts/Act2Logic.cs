using UnityEngine;
using System.Collections;

public class Act2Logic : MonoBehaviour {

	public GameObject Act1;
	public Player ThePlayer;
	public ComputerDesk TheComputer;
	public float IntroCaptionTimeout = 5f;
	public float OutroCaptionTimeout = 5f;
	public GUIStyle TextStyle;
	public SpriteRenderer CameraCurtain;

	private Flow _Flow;

	void OnEnable()
	{
		_Flow = new Flow();
		_Flow.OnEnterState += new StateChangedHandler(OnEnterState);
		_Flow.OnExitState += new StateChangedHandler(OnExitState);
		_Flow.State = Flow.eState.INTRO;

		if (Act1 != null)
		{
			Act1.SetActive(false);
		}

		if (ThePlayer != null)
		{
			ThePlayer.StartAct2();
		}
	}
	
	void OnDisable()
	{
		_Flow.State = Flow.eState.IDLE;
		_Flow.OnEnterState -= new StateChangedHandler(OnEnterState);
		_Flow.OnExitState -= new StateChangedHandler(OnExitState);

		if (Act1 != null)
		{
			Act1.SetActive(true);
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
				if (TheComputer != null)
				{
					if (TheComputer.TimeSpentReadingMail > 5f)
					{
						_Flow.State = Flow.eState.OUTRO;
					}
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
		set
		{
			Color c = TextStyle.normal.textColor;
			c.a = value;
			TextStyle.normal.textColor = c;
		}
	}

	private float CameraCurtainAlpha
	{
		set
		{
			if (CameraCurtain == null) { return; }
			Color c = CameraCurtain.color;
			c.a = value;
			CameraCurtain.color = c;
		}
	}

	void OnGUI()
	{
		switch (_Flow.State)
		{
			case Flow.eState.INTRO:
				CaptionAlpha = Mathf.Clamp01(IntroCaptionTimeout * (IntroCaptionTimeout - _Flow.StateTimer) / IntroCaptionTimeout);
				CameraCurtainAlpha = Mathf.Clamp01((IntroCaptionTimeout - _Flow.StateTimer) / IntroCaptionTimeout);
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					"AT THE OFFICE",
					TextStyle);
				break;

			case Flow.eState.OUTRO:
				float a = Mathf.Clamp01((OutroCaptionTimeout - _Flow.StateTimer) / OutroCaptionTimeout);
				CaptionAlpha = 1f - a;
				CameraCurtainAlpha = 1f - a;
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					"YOU ARE THE MONSTER",
					TextStyle);
				break;
		}
	}

	private void OnEnterState(Flow flow, Flow.eState oldState, Flow.eState newState)
	{
		switch (newState)
		{
			case Flow.eState.INTRO:
				CameraCurtainAlpha = 1f;
				break;

			case Flow.eState.NORMAL:
				CameraCurtainAlpha = 0f;
				break;

			case Flow.eState.IDLE:
				gameObject.SetActive(false);
				break;
		}
	}

	private void OnExitState(Flow flow, Flow.eState oldState, Flow.eState newState)
	{

	}
}
