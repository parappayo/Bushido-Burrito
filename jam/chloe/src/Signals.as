package  
{
	public class Signals 
	{
		// global
		public static const NONE					:int = 0;
		
		// system
		public static const FATAL_ERROR				:int = 1000;
		public static const CONTROLLER_DISCONNECT	:int = 1001;
		public static const NETWORK_DISCONNECT		:int = 1002;
		public static const DEVICE_LOST				:int = 1003;
		public static const SYSTEM_MENU_OPEN		:int = 1004;
		public static const DISK_EJECT				:int = 1005;
		public static const LOAD_FAILED				:int = 1006;
		public static const SAVE_FAILED				:int = 1007;
		public static const PAUSE_GAME				:int = 1008;
		public static const RESUME_GAME				:int = 1009;
		
		// input
		public static const MOVE_UP_KEYUP			:int = 2000;
		public static const MOVE_UP_KEYDOWN			:int = 2001;
		public static const MOVE_DOWN_KEYUP			:int = 2002;
		public static const MOVE_DOWN_KEYDOWN		:int = 2003;
		public static const MOVE_LEFT_KEYUP			:int = 2004;
		public static const MOVE_LEFT_KEYDOWN		:int = 2005;
		public static const MOVE_RIGHT_KEYUP		:int = 2006;
		public static const MOVE_RIGHT_KEYDOWN		:int = 2007;
		public static const ACCEPT_KEYUP			:int = 2008;
		public static const ACCEPT_KEYDOWN			:int = 2009;
		public static const BACK_KEYUP				:int = 2010;
		public static const BACK_KEYDOWN			:int = 2011;
		public static const ACTION_KEYUP			:int = 2012;
		public static const ACTION_KEYDOWN			:int = 2013;
		
		// movement
		public static const MOVEMENT_UPDATE			:int = 3000;
		public static const MOVEMENT_STOP			:int = 3001;
		
		// action
		public static const ACTION_LOCK				:int = 4000;
		public static const ACTION_EXECUTE			:int = 4001;
		
		// animation
		public static const ANIMATION_PLAY			:int = 5000;
		
		// projectile
		public static const PROJECTILE_ADD			:int = 6000;
		public static const PROJECTILE_REMOVE		:int = 6001;

		// effects
		public static const EFFECT_ADD				:int = 7000;
		public static const EFFECT_REMOVE			:int = 7001;
		
		// game specific
		public static const INTERACT_EVENT			:int = 9000;
		public static const LEVEL_RESET				:int = 9001;
		public static const LEVEL_TRANSITION		:int = 9002;
		public static const RADIO_USED				:int = 9003;
		public static const VICTORY					:int = 9004;
		public static const PLAYER_DIED				:int = 9005;

	} // class

} // package
