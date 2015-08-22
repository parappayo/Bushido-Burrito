
public delegate void StateChangedHandler(Flow sender, Flow.eState oldState, Flow.eState newState);

public class Flow {

	public enum eState
	{
		INVALID,
		INTRO,
		NORMAL,
		OUTRO,
		IDLE
	}

	private eState _State;
	public eState State
	{
		get { return _State; }
		set
		{
			if (_State == value)
			{
				return;
			}

			eState oldState = _State;
			_State = value;
			StateTimer = 0f;

			OnExitState(this, oldState, _State);
			OnEnterState(this, oldState, _State);
		}
	}

	public float StateTimer
	{
		get;
		private set;
	}

	public void Update(float elapsed)
	{
		StateTimer += elapsed;
	}

	public event StateChangedHandler OnEnterState;
	public event StateChangedHandler OnExitState;
}
