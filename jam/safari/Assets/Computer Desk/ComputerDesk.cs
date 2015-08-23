using UnityEngine;
using System.Collections;

public class ComputerDesk : MonoBehaviour {

	public float MailTimer = 2f;
	public GameObject ThePlayer;
	public GUIStyle TextStyle;
	public string[] Mail;

	private int _MailIndex;
	private string _MailCaption;
	private bool _ShowMail;
	private float _MailTimer;

	public float TimeSpentReadingMail
	{
		get;
		private set;
	}

	void OnEnable()
	{
		TimeSpentReadingMail = 0f;
		_ShowMail = false;
	}

	void Update()
	{
		if (_ShowMail)
		{
			TimeSpentReadingMail += Time.deltaTime;
		}
	}

	void OnGUI()
	{
		_MailTimer += Time.deltaTime;

		if (_MailTimer > MailTimer)
		{
			_MailTimer = 0f;

			if (_ShowMail)
			{
				ShowNextMail();
			}
			else
			{
				_MailCaption = null;
			}
		}

		if (!string.IsNullOrEmpty(_MailCaption))
		{
				GUI.Label(
					new Rect(Screen.width * 0.2f, Screen.height * 0.3f, Screen.width * 0.6f, Screen.height * 0.3f),
					_MailCaption,
					TextStyle);
		}
	}

	void OnTriggerEnter(Collider other)
	{
		if (other.gameObject != ThePlayer)
		{
			return;
		}

		_ShowMail = true;
		ShowNextMail();
	}

	void OnTriggerExit(Collider other)
	{
		if (other.gameObject != ThePlayer)
		{
			return;
		}
		
		_ShowMail = false;
	}

	private void ShowNextMail()
	{
		if (Mail == null || Mail.Length < 1)
		{
			_MailCaption = null;
			return;
		}

		_MailIndex = (_MailIndex >= 0) ? (_MailIndex % Mail.Length) : 0;
		_MailCaption = Mail[_MailIndex];
		_MailIndex++;
	}
}
