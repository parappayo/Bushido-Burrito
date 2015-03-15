package components 
{
	import wyverntail.core.*;

	public class GridViewToggleControl extends Component
	{
		private var _gridView :GridView;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_gridView = getComponent(GridView) as GridView;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.KEYDOWN_EVENT &&
				args.keyCode == 71) // G key
			{
				_gridView.visible = !_gridView.visible;
				return true;
			}
			
			return false;
		}
		
	} // class

} // package
