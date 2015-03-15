package states
{
	public interface IState
	{
		function update():void;
		function destroy():void;
	}
}